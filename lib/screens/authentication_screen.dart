import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:semester_project/screens/pageview_controller_screen.dart';
import './forgot_password_screen.dart';

enum AuthMode { signup, login }

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  // -- styling --
  // container-decorations
  // * 1. border-radius
  final containerRadius = BorderRadius.circular(10);
  // * 2. box-shadow
  final containerShadow = const [
    BoxShadow(
      color: Color.fromARGB(15, 0, 0, 0),
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];
  // * sign in/up button-style
  final signButtonStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    ),
  );
  // * text-Field borderRadius
  final textFieldBorderRadius = const OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(Radius.circular(50)),
  );

  // ! shared-preferences, to store [username, email, token] on device
  late SharedPreferences localUserData;

  // ! authmode
  AuthMode _authMode = AuthMode.signup;

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  // ! for loading data from shared-preferences
  Future init() async {
    localUserData = await SharedPreferences.getInstance();
  }

  // * form controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // switch auth mode
  void _switchAuthMode() {
    if (_authMode == AuthMode.signup) {
      setState(() {
        _authMode = AuthMode.login;
      });
    } else {
      setState(() {
        _authMode = AuthMode.signup;
      });
    }
  }

  // * to display loading spinner
  var isAddingUser = false;

  // * add user to database
  Future<void> signUpUser() async {
    final nameText = nameController.text;
    final emailText = emailController.text;
    final passwordText = passwordController.text;

    // ! return if any field is empty
    if (nameText == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Name cannot be empty'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          duration: Duration(seconds: 2),
        ),
      );

      return;
    } else if (emailText == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Email cannot be empty'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          duration: Duration(seconds: 2),
        ),
      );

      return;
    } else if (passwordText == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Password cannot be empty'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    // ! show loading spinner
    setState(() {
      isAddingUser = true;
    });

    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'addUser';

    try {
      // ! converting to formData
      FormData formData = FormData.fromMap({
        'name': nameText,
        'email': emailText,
        'password': passwordText,
      });

      // ! sending POST request
      final response = await Dio().post(
        url,
        data: formData,
      );

      // ! clear text fields
      nameController.text = '';
      passwordController.text = '';
      // ! close keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      // *
      if (response.toString() == 'email already used') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email already used'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            duration: Duration(seconds: 2),
          ),
        );

        // ! clear email field
        emailController.text = '';
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('👍 Sign up successfull'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            duration: Duration(seconds: 2),
          ),
        );

        // ! go to login page
        setState(() {
          _authMode = AuthMode.login;
        });
      }
    } catch (err) {
      // ! err
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Could not sign up'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }

    // ! stop loading spinner
    setState(() {
      isAddingUser = false;
    });
  }

  Future<void> loginUser() async {
    final emailText = emailController.text;
    final passwordText = passwordController.text;

    // ! return if any field is empty
    if (emailText == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Email cannot be empty'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          duration: Duration(seconds: 2),
        ),
      );

      return;
    } else if (passwordText == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Password cannot be empty'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    // ! show loading spinner
    setState(() {
      isAddingUser = true;
    });

    // ! getting url
    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'loginUser';

    try {
      // ! converting to formData
      FormData formData = FormData.fromMap({
        'email': emailText,
        'password': passwordText,
      });

      // ! sending POST request
      final response = await Dio().post(
        url,
        data: formData,
      );

      // ! clear text fields
      nameController.text = '';
      passwordController.text = '';
      emailController.text = '';
      // ! close keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      // !
      if (response.toString() == 'invalid data') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠ Email or password is incorrect'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // ! if user logged in, the server sends [name, email, token]
        final name = response.data[0]['name'];
        final email = response.data[0]['email'];
        final token = response.data[0]['token'];

        // * storing data locally
        await localUserData.setString('ep_username', name);
        await localUserData.setString('ep_email', email);
        await localUserData.setString('ep_token', token);

        // ! used to check, if signUp/logIn screen needs to be shown or not
        await localUserData.setBool('ep_loggedin', true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('👍 Log in successfull'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            duration: Duration(seconds: 2),
          ),
        );

        // ! go to home page, if logged in
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PageviewController()),
        );
      }
    } catch (err) {
      // ! err
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Could not log in'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }

    // ! stop loading spinner
    setState(() {
      isAddingUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // width
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // bg-color
          color: const Color(0xFFF8F8F8),
          // padding
          padding: const EdgeInsets.only(
            top: 60,
            bottom: 30,
            left: 30,
            right: 30,
          ),
          // child
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // illustration
              Image.asset(
                _authMode == AuthMode.signup
                    ? 'assets/illustrations/create_account.png'
                    : 'assets/illustrations/login.png',
                width: 200,
              ),

              // text
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Event Planner',
                      style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _authMode == AuthMode.signup
                          ? 'Create an account to start selling and buying services.'
                          : 'Welcome back you\'ve been missed!',
                    ),
                  ],
                ),
              ),

              // form-container
              Container(
                // padding
                padding: const EdgeInsets.all(20),
                // width
                width: MediaQuery.of(context).size.width,
                // decoration
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: containerShadow,
                  borderRadius: containerRadius,
                ),

                // column
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // sign-in/up heading
                    Text(
                      _authMode == AuthMode.signup ? 'Sign up' : 'Log in',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --> textFields

                    // full name (only required while signing up)
                    if (_authMode == AuthMode.signup)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: textFieldBorderRadius,
                            hintText: 'Full Name',
                            prefixIcon: const Icon(PhosphorIcons.userThin),
                            filled: true,
                            fillColor: const Color(0xFFF8F8F8),
                          ),
                        ),
                      )
                    else
                      Container(),

                    // email
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: textFieldBorderRadius,
                          hintText: 'Email',
                          prefixIcon: const Icon(PhosphorIcons.atThin),
                          filled: true,
                          fillColor: const Color(0xFFF8F8F8),
                        ),
                      ),
                    ),

                    // password
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          border: textFieldBorderRadius,
                          hintText: 'Password',
                          prefixIcon: const Icon(PhosphorIcons.passwordThin),
                          filled: true,
                          fillColor: const Color(0xFFF8F8F8),
                        ),
                      ),
                    ),

                    // forgot password btn
                    if (_authMode == AuthMode.login)
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                        ),
                        style: ButtonStyle(
                          alignment: Alignment.centerRight,
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(),

                    // white-spacing
                    if (_authMode == AuthMode.signup)
                      const SizedBox(height: 20)
                    else
                      Container(),

                    // button
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: isAddingUser == false
                            ? () {
                                if (_authMode == AuthMode.signup) {
                                  signUpUser();
                                } else {
                                  loginUser();
                                }
                              }
                            : null,
                        // ! if user is being added or being logged in. show loading spinner
                        child: isAddingUser == false
                            ? Text(
                                _authMode == AuthMode.signup
                                    ? 'Sign up'
                                    : 'Log in',
                              )
                            : const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                        style: signButtonStyle,
                      ),
                    ),

                    // * switch between sign in/up
                    TextButton(
                      child: Text(
                        _authMode == AuthMode.signup
                            ? 'Already a member? Login'
                            : 'Not a member? Sign up',
                      ),
                      onPressed: _switchAuthMode,
                      style: signButtonStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
