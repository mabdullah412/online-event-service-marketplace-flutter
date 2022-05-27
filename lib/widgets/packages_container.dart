import 'package:flutter/material.dart';
import 'package:semester_project/widgets/create_package.dart';

class PackagesContainer extends StatelessWidget {
  const PackagesContainer({Key? key}) : super(key: key);

  // styling
  // light-text
  final lightTextStyle = const TextStyle(
    color: Color(0xFF777777),
  );

  // * modal sheet for create-package
  void _createPackage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const CreatePackage();
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

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
          const SizedBox(height: 30),
          Text(
            'You have created no packages yet',
            style: lightTextStyle,
          ),
          TextButton(
            child: const Text('Create a package'),
            onPressed: () {
              _createPackage(context);
            },
          ),
        ],
      ),
    );
  }
}
