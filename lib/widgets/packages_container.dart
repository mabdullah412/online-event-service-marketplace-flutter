import 'package:flutter/material.dart';

class PackagesContainer extends StatelessWidget {
  const PackagesContainer({Key? key}) : super(key: key);

  // styling
  // light-text
  final lightTextStyle = const TextStyle(
    color: Color(0xFF777777),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/illustrations/no_packages.png',
            width: 100,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            'You have created no packages yet',
            style: lightTextStyle,
          ),
        ],
      ),
    );
  }
}
