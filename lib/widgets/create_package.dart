import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // ! shared-preferences, to get [token and email] of the user stored on device
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

  final nameController = TextEditingController();
  bool showPackageCreated = false;
  bool isCreatingPackage = false;

  Future<void> _createPackage() async {
    final nameText = nameController.text;

    // ! close keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    // ! package name shouldn't be empty
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
    }

    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/addPackage';

    // ! show loading spinner
    setState(() {
      isCreatingPackage = true;
    });

    try {
      // ! converting to formData
      // * id format => "email currentTime"
      final formData = FormData.fromMap({
        'id': userEmail + ' ' + DateTime.now().toString(),
        'email': userEmail,
        'name': nameText,
        'token': apiToken,
      });

      final response = await Dio().post(
        url,
        data: formData,
      );

      // ! handling server response
      if (response.toString() == 'created') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('👍 Package added successfully'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            duration: Duration(seconds: 1),
          ),
        );

        setState(() {
          showPackageCreated = true;
        });

        // * wait for user to see package created message
        await Future.delayed(const Duration(seconds: 2));

        // ! close modal sheet
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠ Error occured'),
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
      // *

    } catch (err) {
      // ! err
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Could not create package'),
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
  }

  @override
  void initState() {
    super.initState();
    loadApiTokenAndEmail();
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
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Package Title'),
            ),

            // * white-spacing
            const SizedBox(height: 10),

            // * message
            if (showPackageCreated)
              const Text(
                ' -- 👍 Package Created Successfully --',
                textAlign: TextAlign.center,
              ),

            if (showPackageCreated) const SizedBox(height: 10),

            // * btn
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: isCreatingPackage == false ? _createPackage : null,
                child: isCreatingPackage == false
                    ? const Text('Apply')
                    : const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
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
