import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:semester_project/widgets/create_package.dart';

class AddToPackage extends StatefulWidget {
  const AddToPackage({Key? key}) : super(key: key);

  @override
  State<AddToPackage> createState() => _AddToPackageState();
}

class _AddToPackageState extends State<AddToPackage> {
  // add button style
  final setBtnStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
  );

  void _addToDefault() {
    // close the modal after data is entered
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to default package.'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        duration: Duration(seconds: 2),
      ),
    );
    // close the modal sheet
    Navigator.of(context).pop();
  }

  // * create package
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
    return SingleChildScrollView(
      child: Container(
        // width
        width: MediaQuery.of(context).size.width,
        // padding
        padding: EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Add to package',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: ElevatedButton.icon(
                onPressed: () {
                  _createPackage(context);
                },
                label: const Text('create'),
                icon: const Icon(PhosphorIcons.plusBold),
                style: setBtnStyle,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(PhosphorIcons.package),
              title: const Text('Default package'),
              onTap: _addToDefault,
            ),
          ],
        ),
      ),
    );
  }
}
