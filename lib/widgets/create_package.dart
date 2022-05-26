import 'package:flutter/material.dart';

class CreatePackage extends StatefulWidget {
  const CreatePackage({Key? key}) : super(key: key);

  @override
  State<CreatePackage> createState() => _CreatePackageState();
}

class _CreatePackageState extends State<CreatePackage> {
  // add button style
  final setBtnStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Create a package',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            // * textfield
            const TextField(
              decoration: InputDecoration(labelText: 'Package Title'),
            ),

            // * white-spacing
            const SizedBox(height: 10),

            // * btn
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Apply'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
