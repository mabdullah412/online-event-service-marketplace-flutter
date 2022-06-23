const express = require('express');
const path = require('path');
const multer = require('multer');
const mysql = require('mysql');
const shajs = require('sha.js');
const fs = require('fs');

const port = 3000;
const app = express();

// ! multer file upload destination
const upload = multer({ dest: 'temp_storage/images/' });

// setting up 'public' directory for using static files like css
app.use(express.static('public'));
app.use('/images', express.static('images'));

// sql connection
const sqlCon = mysql.createConnection({
    host: 'localhost',
    user: 'dbadmin',
    password: '512441',
    database: 'event_planner'
});
// connecting to mysql server
sqlCon.connect(
    function (err) {

        if (err) {
            // res.send(`${currentTime} ---> ` + 'mysql connection error');
            console.log('---> mysql connection error');
            console.log(err);
        } else {
            console.log('---> mysql connection successful');
        }
    }
);

// ! for website
app.get('/', function (req, res) {
    res.sendFile(__dirname + "/index.html");
});

/*
    for creating the database after running 
    server for the first time
*/
// ! ----------> creating event_planner database
app.get('/event_planner/create_database/db', function (req, res) {
    sqlCon.query(
        'create database event_planner',
        function (err, result) {
            if (!err) {
                console.log('---> event_planner database created successfully');
                // res.send('event_planner database created successfully');
            } else {
                console.log('---> event_planner database could not be created');
                console.log(err);
            }
        }
    );
});

// ! ----------> creating user relation
app.get('/event_planner/create_database/relation/user', function (req, res) {
    sqlCon.query(
        'CREATE TABLE user(email VARCHAR(50) PRIMARY KEY, name VARCHAR(40), password VARCHAR(70))',
        function (err, result) {
            if (!err) {
                console.log('---> user table created successfully');
                res.send('user table created successfully');
            } else {
                console.log('---> user table could not be created');
                console.log(err);
                res.send('user table could not be created');
            }
        }
    );
});
// ! ----------> creating category relation
app.get('/event_planner/create_database/relation/category', function (req, res) {
    sqlCon.query(
        'CREATE TABLE category(c_id VARCHAR(30) PRIMARY KEY, title VARCHAR(30), description VARCHAR(60), image_title VARCHAR(20))',
        function (err, result) {
            if (!err) {
                console.log('---> category table created successfully');
                res.send('category table created successfully');
            } else {
                console.log('---> category table could not be created');
                console.log(err);
                res.send('category table could not be created');
            }
        }
    );
});
// ! ----------> creating package relation
app.get('/event_planner/create_database/relation/package', function (req, res) {
    sqlCon.query(
        'CREATE TABLE package(title VARCHAR(30), email VARCHAR(50), FOREIGN KEY (email) REFERENCES user(email) ON DELETE CASCADE)',
        function (err, result) {
            if (!err) {
                console.log('---> package table created successfully');
                res.send('package table created successfully');
            } else {
                console.log('---> package table could not be created');
                console.log(err);
                res.send('package table could not be created');
            }
        }
    );
});
// ! ----------> creating user_token relation
app.get('/event_planner/create_database/relation/user_token', function (req, res) {
    sqlCon.query(
        'CREATE TABLE user_token(email VARCHAR(50), token VARCHAR(70), FOREIGN KEY (emaik) REFERENCES user(email) ON DELETE CASCADE)',
        function (err, result) {
            if (!err) {
                console.log('---> user_token table created successfully');
                res.send('user_token table created successfully');
            } else {
                console.log('---> user_token table could not be created');
                console.log(err);
                res.send('user_token table could not be created');
            }
        }
    );
});


// ! populating relations

// ! ----------> populating categories
app.post('/event_planner/create_database/populate/category', function (req, res) {

    const id = req.body.id;
    const title = req.body.title;
    const description = req.body.description;
    const image_title = req.body.image_title;

    const insertInto = 'INSERT INTO category(id, title, description, image_title)values';

    sqlCon.query(
        insertInto + `("${id}", "${title}", "${description}", "${image_title}")`,
        function (err, result) {
            if (!err) {
                console.log('---> category added successfully');
                // res.send('category added successfully');
            } else {
                console.log('---> category could not be added');
                console.log(err);
            }
        }
    );

});
// ! ----------> signing-up user
app.post('/event_planner/api/addUser', upload.none(), function (req, res) {

    // const id = req.body.id;
    const name = req.body.name;
    const email = req.body.email;
    const password = req.body.password;

    var emailDataReturned;

    // ! checking if the email was already used to create an account
    sqlCon.query(
        `SELECT COUNT(*) FROM user WHERE email LIKE "${email}"`,
        function (err, result) {
            if (err) {
                console.log('---> could not check for user');
                console.log(err);
            } else {
                // ! if no error occured
                console.log('---> checked for user successfully');
                // console.log(result[0]['COUNT(*)']);
                emailDataReturned = result[0]['COUNT(*)'];
                // console.log(emailDataReturned);

                // ! if email is already used, then count must be greater than 0;
                if (emailDataReturned != '0') {
                    console.log('---> Email already used');
                    res.send('email already used');
                    return;
                }

                // ! if email was not already used than, add email to database

                // * encrypting passord
                const encryptedPassword = shajs('sha256').update(password).digest('hex');

                const insertIntoUser = 'INSERT INTO user(name, email, password)VALUES';

                // * adding to database
                sqlCon.query(
                    insertIntoUser + `("${name}", "${email}", "${encryptedPassword}")`,
                    function (err_, result_) {
                        if (!err_) {
                            console.log('---> user added successfully');
                            // res.send('user added successfully');

                            // ! now creating and adding users token in the database
                            const insertIntoAuth = 'INSERT INTO user_token(email, token)VALUES';

                            let token = authclass.createToken(email);

                            sqlCon.query(
                                insertIntoAuth + `("${email}", "${token}")`,
                                function (err__, result__) {
                                    if (!err__) {
                                        console.log('---> users token added successfully');
                                        // res.send(token);
                                        res.send('account created successfully');
                                    } else {
                                        console.log('---> users token could\'nt be added');
                                    }
                                }
                            );

                        } else {
                            console.log('---> user could not be added');
                            console.log(err_);
                            res.send('user could not be added');
                        }
                    }
                );

            }
        }
    );


});

// ! ----------> logining-in user
app.post('/event_planner/api/loginUser', upload.none(), function (req, res) {

    const email = req.body.email;
    const password = req.body.password;

    // * encrypting passord
    const encryptedPassword = shajs('sha256').update(password).digest('hex');

    var emailDataReturned;

    // ! checking if the email and password exist in database
    sqlCon.query(
        `SELECT COUNT(*) FROM user WHERE email LIKE "${email}" AND password LIKE "${encryptedPassword}"`,
        function (err, result) {
            if (err) {
                console.log('---> could not check for user');
                console.log(err);
            } else {
                // ! if no error occured
                console.log('---> checked for user successfully');
                // console.log(result[0]['COUNT(*)']);
                emailDataReturned = result[0]['COUNT(*)'];
                // console.log(emailDataReturned);

                // ! if email and password exist, then count must be greater than 0;
                if (emailDataReturned != '0') {
                    console.log('---> User exists');
                    // res.send('User exists');
                    // return;
                } else {
                    console.log('---> incorrect data');
                    res.send('invalid data');
                    return;
                }

                // ! if user exists, send api token with name and email
                sqlCon.query(
                    `SELECT user.name, user.email, user_token.token
                    FROM user, user_token
                    WHERE user.email LIKE "${email}" AND user.email = user_token.email`,
                    function (err_, result_) {
                        if (!err) {
                            // console.log(result_);
                            // res.send(result_[0]['token']);
                            // console.log(result_);
                            res.send(result_);
                        } else {
                            console.log('---> could not check for key');
                        }
                    }
                );
            }
        }
    );

});
// ! ----------> adding user service
app.post('/event_planner/api/addService', upload.single('image'), function (req, res) {

    // * getting and assigning text data
    const token = req.body.token;

    // ! checking authorization first
    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const email = req.body.email;
            const date_created = req.body.date_created;
            const id = email + ' ' + date_created;

            const name = req.body.name;
            const description = req.body.description;
            const price = req.body.price;
            const rating = 0;
            const category = req.body.category;
            const location = req.body.location;
            const image_title = req.file.originalname;

            // *getting file data
            const tempPath = req.file.path;
            const fileName = req.file.originalname;
            const targetPath = path.join(__dirname, "/images/" + fileName);

            // * moving file to uploads/images
            fs.rename(tempPath, targetPath, (err) => {
                if (err) {
                    console.log('error occured');
                } else {
                    console.log('file uploaded and moved');
                }
            });

            const insertIntoService = 'INSERT INTO service(id, email, name, description, price, rating, location, date_created, image_title, category)VALUES';

            sqlCon.query(
                insertIntoService + `("${id}", "${email}", "${name}", "${description}", ${price}, ${rating}, "${location}", "${date_created}", "${image_title}", "${category}")`,
                function (err, result) {
                    if (!err) {
                        console.log('---> service created by ' + email);
                        res.send('created');
                    } else {
                        res.send('error');
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }

    });

});
// ! ----------> adding user package
app.post('/event_planner/api/addPackage', upload.none(), function (req, res) {

    // * getting and assigning text data
    const token = req.body.token;

    // ! checking authorization first
    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const id = req.body.id;
            const email = req.body.email;
            const name = req.body.name;

            const insertIntoPackage = 'INSERT INTO package(id, email, name)VALUES';

            sqlCon.query(
                insertIntoPackage + `("${id}", "${email}", "${name}")`,
                function (err, result) {
                    if (!err) {
                        console.log('---> package created by ' + email);
                        res.send('created');
                    } else {
                        res.send('error');
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }

    });

});

// ! ----------> adding service to package
app.post('/event_planner/api/addServiceToPackage', upload.none(), function (req, res) {

    // * getting and assigning text data
    const token = req.body.token;

    // ! checking authorization first
    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const packageId = req.body.packageId;
            const serviceId = req.body.serviceId;

            // ! checking if the service already exists in the package
            sqlCon.query(
                `SELECT COUNT(*)
                FROM package_item 
                WHERE p_id = "${packageId}" and s_id = "${serviceId}"`,
                function (err, result) {
                    if (!err) {
                        // ! if no error occured
                        var countResult = result[0]['COUNT(*)'];

                        // ! if this service is in this package, then count must be greater than 0;
                        if (countResult != '0') {
                            console.log('---> service already in package, increasing count');

                            // ! increasing count of the service, and returning
                            sqlCon.query(
                                `SELECT increase_count("${packageId}", "${serviceId}");`,
                                function (err_, result_) {
                                    if (!err_) {
                                        console.log('---> count increased');
                                        res.send('added');
                                    } else {
                                        console.log('---> could not increase count');
                                    }
                                }
                            );

                            return;
                        }

                        // ! if this servie was not in package
                        const insertDataIntoPackage = 'INSERT INTO package_item(p_id, s_id, count)VALUES';

                        sqlCon.query(
                            insertDataIntoPackage + `("${packageId}", "${serviceId}", 1)`,
                            function (err_, result_) {
                                if (!err_) {
                                    console.log('---> service added into package ' + packageId);
                                    res.send('added');
                                } else {
                                    res.send('error');
                                }
                            }
                        );

                    } else {
                        console.log('---> could not check for user');
                        console.log(err);
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }

    });

});

// ! ---------> placing order
app.post('/event_planner/api/placeOrder', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.body.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            // todo --> if package was empty, do not send this req.

            const packageId = req.body.packageId;
            const date_created = req.body.date_created;
            const email = req.body.email;
            const price = req.body.price;

            const newOrderId = email + ' ' + date_created;

            var insertIntoOrder = "INSERT INTO orders(id, email, total_price, date_created)VALUES";

            // ! creating order first
            sqlCon.query(
                insertIntoOrder + `("${newOrderId}", "${email}", ${price}, "${date_created}")`,
                function (err, result) {

                    if (!err) {

                        // ! after createing order
                        // ! getting items in the package
                        sqlCon.query(
                            `SELECT *
                            FROM package_item
                            WHERE p_id = "${packageId}"`,
                            function (err_, result_) {

                                if (!err_) {

                                    // ! after getting the items,
                                    // ! adding every item from package to order_items
                                    var itemCount = result_.length;

                                    for (let index = 0; index < itemCount; index++) {
                                        const item = result_[index];

                                        var insertIntoOrderItem = "INSERT INTO order_item(o_id, s_id, count, status)VALUES";
                                        sqlCon.query(
                                            insertIntoOrderItem + `("${newOrderId}", "${item['s_id']}", ${item['count']}, "waiting")`,
                                            function (err__, result__) {

                                                if (!err__) {
                                                    console.log('---> added service ' + item['s_id'] + ' into order ' + newOrderId)
                                                } else {
                                                    console.log('---> err adding service');
                                                    console.log(err__);
                                                }

                                            }
                                        );

                                    }
                                    
                                    console.log('---> added all into order_item');
                                    res.send('placed');
                                    
                                } else {
                                    console.log('---> err getting items from package');
                                    console.log(err_);
                                }
                                
                                

                            }
                        );

                    } else {
                        console.log('---> error creating order');
                        console.log('err');
                    }


                }
            );

            

        } else {
            res.send('user not authorized');
        }

    });

});

// ! ---------> delete package
app.post('/event_planner/api/removePackage', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.body.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const packageId = req.body.packageId;

            sqlCon.query(
                `DELETE package
                FROM package
                WHERE id = "${packageId}"`,
                function (err, result) {
                    if (err) {
                        console.log('---> remove package error');
                        console.log(err);
                    } else {
                        console.log('---> removed package ' + packageId + ' successfull');
                        res.send('removed');
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }
    });
});

// ! ---------> cancel order
app.post('/event_planner/api/cancelOrder', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.body.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const orderId = req.body.orderId;

            sqlCon.query(
                `DELETE orders
                FROM orders
                WHERE id = "${orderId}"`,
                function (err, result) {
                    if (err) {
                        console.log('---> cancel order error');
                        console.log(err);
                    } else {
                        console.log('---> cancelled order ' + orderId + ' successfully');
                        res.send('cancelled');
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }
    });
});

// ! ---------> remove service
app.post('/event_planner/api/removeService', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.body.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const serviceId = req.body.serviceId;

            sqlCon.query(
                `DELETE service
                FROM service
                WHERE id = "${serviceId}"`,
                function (err, result) {
                    if (err) {
                        console.log('---> remove service error');
                        console.log(err);
                    } else {
                        console.log('---> removed service ' + serviceId + ' successfully');
                        res.send('removed');
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }
    });
});

// ! ---------> complete sale 
app.post('/event_planner/api/completeSale', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.body.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const orderId = req.body.orderId;
            const serviceId = req.body.serviceId;

            sqlCon.query(
                `UPDATE order_item
                SET status = "completed"
                WHERE o_id = "${orderId}" and s_id = "${serviceId}"`,
                function (err, result) {
                    if (err) {
                        console.log('---> completing order error');
                        console.log(err);
                    } else {
                        console.log('---> completed sale for item ' + serviceId + ' from order ' + orderId);
                        res.send('completed');
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }
    });
});

// ! ---------> select all categories from table
app.get('/event_planner/api/category/:token', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.params.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            sqlCon.query(
                `select * from category`,
                function (err, result) {
                    if (err) {
                        console.log('---> select data error');
                        console.log(err);
                    } else {
                        console.log('---> select data from table category successfull');
                        res.send(result);
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }
    });
});
// ! ---------> select all packages from table
app.get('/event_planner/api/package/:email/:token', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.params.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const email = req.params.email;

            sqlCon.query(
                `SELECT *
                FROM package
                WHERE email = "${email}"`,
                function (err, result) {
                    if (err) {
                        console.log('---> select data error');
                        console.log(err);
                    } else {
                        console.log('---> select data from table package successfull for user ' + email);
                        res.send(result);
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }
    });
});
// ! ---------> select all packages from table
app.get('/event_planner/api/order/:email/:token', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.params.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const email = req.params.email;

            sqlCon.query(
                `SELECT *
                FROM orders
                WHERE email = "${email}"`,
                function (err, result) {
                    if (err) {
                        console.log('---> select data error');
                        console.log(err);
                    } else {
                        console.log('---> select data from orders successfull for user ' + email);
                        res.send(result);
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }
    });
});
// ! ---------> select all services from table, and name of service seller
app.get('/event_planner/api/service/:category/:token', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.params.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const category = req.params.category;

            sqlCon.query(
                `SELECT user.name as s_name, service.*
                FROM service, user
                WHERE user.email = service.email and service.category = "${category}"`,
                function (err, result) {
                    if (err) {
                        console.log('---> select data error');
                        console.log(err);
                    } else {
                        console.log('---> select data of services of type ' + category + ' successfull');
                        res.send(result);
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }
    });
});

// ! ---------> select all services from package, and name of service seller, and count of that service
app.get('/event_planner/api/serviceFromPackage/:packageId/:token', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.params.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const packageId = req.params.packageId;

            sqlCon.query(
                `SELECT user.name as s_name, service.*, package_item.count as "count"
                FROM package_item, service, user
                WHERE package_item.p_id = "${packageId}" and service.id = s_id and user.email = service.email`,
                function (err, result) {
                    if (err) {
                        console.log('---> select data error');
                        console.log(err);
                    } else {
                        console.log('---> select services from package ' + packageId + ' successfull');
                        res.send(result);
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }
    });
});

// ! ---------> select all services from order, and name of service seller, and count of that service
app.get('/event_planner/api/serviceFromOrder/:orderId/:token', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.params.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const orderId = req.params.orderId;

            sqlCon.query(
                `SELECT user.name as s_name, service.*, order_item.count as "count", order_item.status
                FROM order_item, service, user
                WHERE order_item.o_id = "${orderId}" and service.id = s_id and user.email = service.email`,
                function (err, result) {
                    if (err) {
                        console.log('---> select data error');
                        console.log(err);
                    } else {
                        console.log('---> select services from package ' + orderId + ' successfull');
                        res.send(result);
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }
    });
});

// ! ---------> select all services for user, for seller probly
app.get('/event_planner/api/myservices/:email/:token', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.params.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const email = req.params.email;

            sqlCon.query(
                `SELECT user.name as s_name, service.*
                FROM service, user
                WHERE service.email = "${email}" and user.email = service.email`,
                function (err, result) {
                    if (err) {
                        console.log('---> select data error');
                        console.log(err);
                    } else {
                        console.log('---> selected services of user ' + email + ' successfull');
                        res.send(result);
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }
    });
});

// ! ---------> select all sales for seller, and name, email of buyer, and the service bought and its data and count
app.get('/event_planner/api/sales/:email/:token', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.params.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const email = req.params.email;

            sqlCon.query(
                `SELECT orders.id as order_id, user.name as buyer_name, user.email as buyer_mail, service.name as service_name, service.id as service_id, service.price, service.image_title, service.category, order_item.count, orders.date_created
                FROM order_item, service, orders, user
                WHERE order_item.s_id = service.id and service.email = "${email}" and order_item.o_id = orders.id and orders.email = user.email and order_item.status = "waiting"`,
                function (err, result) {
                    if (err) {
                        console.log('---> select data error');
                        console.log(err);
                    } else {
                        console.log('---> selected sales for user ' + email + ' successfull');
                        res.send(result);
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }
    });
});

// ! ---------> select all sales amount
app.get('/event_planner/api/salesCount/:email/:token', upload.none(), function (req, res) {

    // ! checking authorization first
    const token = req.params.token;

    authclass.isUserAuthorized(token).then(function (isAuth) {

        if (isAuth) {

            const email = req.params.email;

            sqlCon.query(
                `SELECT COUNT(*)
                FROM order_item, service, orders, user
                WHERE order_item.s_id = service.id and service.email = "${email}" and order_item.o_id = orders.id and orders.email = user.email and order_item.status = "waiting"`,
                function (err, result) {
                    if (err) {
                        console.log('---> select data error');
                        console.log(err);
                    } else {
                        console.log('---> selected sales for user ' + email + ' successfull');
                        res.send(result[0]);
                    }
                }
            );

        } else {
            res.send('user not authorized');
        }
    });
});

app.listen(port, () => {
    console.log(`---> Server started on port ${port}`);
});



class Authorization {
    constructor() { }

    // * check if the user is authorized
    isUserAuthorized(token) {

        return new Promise(function (resolve, reject) {

            let tokenDataReturned;

            sqlCon.query(
                `SELECT COUNT(*) FROM user_token WHERE token LIKE "${token}"`,
                function (err, result) {
                    if (err) {
                        console.log('---> authorization not checked');
                        console.log(err);

                        return reject(err);

                    } else {
                        console.log('---> authorization checking successfull');

                        tokenDataReturned = result[0]['COUNT(*)'];

                        // ! if token exists, then count must be greater than 0;
                        if (tokenDataReturned != '0') {
                            console.log('---> User authorized');
                            // return true;
                            resolve(true);
                            // console.log(token);
                        } else {
                            console.log('---> User not authorized');
                            // return false;
                            resolve(false);
                            // console.log(token);
                        }
                    }
                }
            );

        });

    }

    // * create and returns an authorization token
    createToken(email) {
        const date_obj = new Date();

        let day = date_obj.getDate();
        let month = 1 + date_obj.getMonth();
        let year = date_obj.getFullYear();
        let hour = date_obj.getHours();
        let minute = date_obj.getMinutes();
        let second = date_obj.getSeconds();
        let mili_seconds = date_obj.getMilliseconds();

        // * email, current date, current time string
        // * email dd/mm/yyyy hrs:mns:secs:mils
        let dateTimeNow = email + ' ' + day + '/' + month + '/' + year + ' ' + hour + ':' + minute + ':' + second + ':' + mili_seconds;

        // * hashing the current time using SHA-256 to create authorization token
        let token = shajs('sha256').update(dateTimeNow).digest('hex');

        return token;
    }
}

// ! testing Authorization class
let authclass = new Authorization();

/*

authclass.isUserAuthorized(token).then(function(isAuth) {

    if (isAuth) {
        
    } else {
        res.send('user not authorized');
    }

});

*/