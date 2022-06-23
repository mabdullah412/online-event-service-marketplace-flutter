import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/screens/service_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderServices extends StatefulWidget {
  const OrderServices({
    Key? key,
    required this.id,
    required this.dateTime,
    required this.price,
  }) : super(key: key);

  // * order id
  final String id;
  // * order date
  final DateTime dateTime;
  // * order price
  final double price;

  @override
  State<OrderServices> createState() => _OrderServicesState();
}

class _OrderServicesState extends State<OrderServices> {
  // ! shared-preferences, to get [token] of the user stored on device
  late SharedPreferences localUserData;
  String apiToken = '';
  String userEmail = '';

  Future<void> loadApiTokenAndEmail() async {
    localUserData = await SharedPreferences.getInstance();
    String storedToken = localUserData.getString('ep_token') as String;
    String storedEmail = localUserData.getString('ep_email') as String;

    setState(() {
      apiToken = storedToken;
      userEmail = storedEmail;
    });
  }

  var items = [];
  bool foundItems = false;
  bool foundError = false;

  Future<void> getOrderItems() async {
    // get url from EndPoint
    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/serviceFromOrder/';
    // adding id of the order
    url += widget.id + '/';
    // adding token
    url += apiToken;

    try {
      final response = await Dio().get(url);

      final jsonData = response.data as List;

      // ! (checking mounted), to see that if the widget is still in the tree or not
      if (mounted) {
        setState(() {
          items = jsonData;
          foundItems = true;
        });
      }
    } catch (err) {
      // ! (checking mounted), to see that if the widget is still in the tree or not
      if (mounted) {
        setState(() {
          foundError = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // ! get api token
    // ! then get package items
    loadTokenAndItems();
  }

  Future<void> loadTokenAndItems() async {
    await loadApiTokenAndEmail();
    getOrderItems();
  }

  @override
  Widget build(BuildContext context) {
    var url = Provider.of<EndPoint>(context, listen: false).imageEndpoint;

    return SingleChildScrollView(
      child: Container(
        // width
        width: MediaQuery.of(context).size.width,

        // padding
        padding: EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ! order id
            Text(
              'Order ID #\n' + widget.id,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            // ! white-space
            const SizedBox(height: 10),

            // ! divider
            const Divider(color: Colors.grey),

            // ! white-space
            const SizedBox(height: 10),

            // ! order created
            Text(
              'Date placed: ' +
                  widget.dateTime.day.toString() +
                  '/' +
                  widget.dateTime.month.toString() +
                  '/' +
                  widget.dateTime.year.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),

            // ! white-space
            const SizedBox(height: 10),

            // ! divider
            const Divider(color: Colors.black),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Item'),
                  Text('Quantity'),
                ],
              ),
            ),

            // ! divider
            const Divider(color: Colors.black),

            // ! items
            if (foundItems)
              SizedBox(
                // height
                height: 250,
                // child
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    final orderStatus = item['status'];

                    return ListTile(
                      // * on Tap
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServicePage(
                              sId: item['id'],
                              sSeller: item['s_name'],
                              sSellerEmail: item['email'],
                              sName: item['name'],
                              sDescription: item['description'],
                              sRating: double.parse(item['rating'].toString()),
                              sPrice: double.parse(item['price'].toString()),
                              imageAddress: item['image_title'],
                              sLocation: item['location'],
                            ),
                          ),
                        );
                      },

                      // * image
                      leading: Stack(
                        alignment: Alignment.center,
                        children: [
                          // ! image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              url + item['image_title'],
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                            ),
                          ),

                          // ! order-completed or not
                          if (orderStatus == 'completed')
                            const Icon(
                              PhosphorIcons.checkCircleBold,
                              color: Colors.white,
                            ),
                        ],
                      ),

                      // * title
                      title: Text(item['name']),

                      // * price
                      subtitle: Text('Rs. ' + item['price'].toString()),

                      // * quantity
                      trailing: Text(
                        item['count'].toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  },
                ),
              )
            else
              const SizedBox(
                height: 250,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            // ! Total
            const Divider(color: Colors.black),

            Container(
              // padding
              padding: const EdgeInsets.symmetric(
                // vertical: 10,
                horizontal: 15,
              ),
              // width
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(widget.price.toString()),
                ],
              ),
            ),

            const Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
