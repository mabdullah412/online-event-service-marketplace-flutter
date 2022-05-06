import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
  // primary-text-color
  final primaryTextColor = const Color(0xFF333333);
  // button-style
  final packageButtonStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // width
        width: MediaQuery.of(context).size.width,
        // bg-color
        color: const Color(0xFFF8F8F8),
        // padding
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 30,
          right: 20,
          left: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // welcome message
            Text(
              'Hi, Good Morning',
              style: TextStyle(
                color: primaryTextColor,
              ),
            ),
            Text(
              'Muhammad Abdullah',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: primaryTextColor,
              ),
            ),
            // carousel
            Container(
              // margin
              margin: const EdgeInsets.only(
                top: 25,
              ),
              // constraints
              width: MediaQuery.of(context).size.width,
              height: 300,
              // child
              child: const Center(
                child: Text('Carousel'),
              ),
              // decoration
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: containerShadow,
                borderRadius: containerRadius,
              ),
            ),
            // create a package
            Container(
              // margin
              margin: const EdgeInsets.only(top: 25),
              // padding
              padding: const EdgeInsets.all(20),
              // constraints
              width: MediaQuery.of(context).size.width,
              // child
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a package',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Create your own custom packages by adding the services you desire and pay for the whole package in one click.',
                    style: TextStyle(
                      color: Color(0xFF777777),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Create package'),
                      style: packageButtonStyle,
                    ),
                  ),
                ],
              ),
              // decoration
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: containerShadow,
                borderRadius: containerRadius,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
