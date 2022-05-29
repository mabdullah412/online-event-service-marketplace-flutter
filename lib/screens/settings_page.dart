import 'package:flutter/material.dart';
import 'package:semester_project/screens/authentication_page.dart';
import 'package:semester_project/widgets/edit_endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _editEndpoint(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const EditEndpoint();
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

  bool isLoggingOut = false;

  Future<void> _logout() async {
    localUserData = await SharedPreferences.getInstance();

    // ! show loading spinner
    setState(() {
      isLoggingOut = true;
    });

    // * storing data locally
    await localUserData.clear();

    // ! stop showing loading spinner
    setState(() {
      isLoggingOut = false;
    });

    // ! go-to login/signup page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF333333),
        ),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Container(
          // width
          width: MediaQuery.of(context).size.width,
          // bg-color
          color: const Color(0xFFF8F8F8),
          // padding
          padding: const EdgeInsets.only(
            top: 40,
            right: 20,
            left: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ! edit endpoint
              TextButton(
                onPressed: () {
                  _editEndpoint(context);
                },
                child: const ListTile(
                  title: Text('Edit Endpoint'),
                ),
              ),

              const Divider(),

              // ! edit endpoint
              TextButton(
                onPressed: _logout,
                child: const ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
