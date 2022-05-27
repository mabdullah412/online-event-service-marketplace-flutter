import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // -- styling --
  // container-decorations
  // 1. border-radius
  final containerRadius = BorderRadius.circular(10);
  // 2. box-shadow
  final containerShadow = const [
    BoxShadow(
      color: Color.fromARGB(15, 0, 0, 0),
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // illustration
              Image.asset(
                'assets/illustrations/forgot_password.png',
                width: 200,
              ),

              // text
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 36,
                        height: 1,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Don\'t worry! it happens. Please enter the email address associated with your account.',
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),

              // FORM and BACK-BTN
              Column(
                children: [
                  // FORM
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

                    // child
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // email
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: const TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              hintText: 'Email',
                              prefixIcon: Icon(PhosphorIcons.atThin),
                              filled: true,
                              fillColor: Color(0xFFF8F8F8),
                            ),
                          ),
                        ),

                        // white-spacing

                        // submit btn
                        const SizedBox(height: 20),

                        // button
                        SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Submit'),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // BACK-BTN
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: const Text('Back'),
                      icon: const Icon(PhosphorIcons.arrowLeft),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
