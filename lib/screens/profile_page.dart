import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/user_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
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

  // ! shared-preferences, to get [username] of the user stored on device
  String username = '';

  late SharedPreferences localUserData;
  Future loadUsername() async {
    localUserData = await SharedPreferences.getInstance();
    String storedName = localUserData.getString('ep_username') as String;

    setState(() {
      username = storedName;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    // ! seller mode
    bool _sellerMode = Provider.of<UserMode>(context, listen: false).sellerMode;

    return Container(
      // width
      width: MediaQuery.of(context).size.width,
      // bg-color
      color: const Color(0xFFF8F8F8),
      // padding
      padding: const EdgeInsets.only(
        top: 30,
        right: 20,
        left: 20,
      ),
      child: Column(
        children: [
          // ! user info
          Container(
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              leading: const CircleAvatar(
                child: Icon(PhosphorIcons.userBold),
                backgroundColor: Color(0xFF333333),
                radius: 30,
              ),
              title: Text(username),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: containerShadow,
              borderRadius: containerRadius,
            ),
          ),

          const SizedBox(height: 20),

          // ! User Mode
          Container(
            // width
            width: MediaQuery.of(context).size.width,
            // padding
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 0,
            ),
            // child
            child: SwitchListTile(
              title: const Text('Seller mode'),
              activeColor: const Color(0xFF333333),
              value: _sellerMode,
              onChanged: (val) {
                // ! update seller mode provider state
                Provider.of<UserMode>(context, listen: false).toggleUserMode();

                // ! update seller mode for current widget
                setState(() {
                  _sellerMode = val;
                });
              },
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
    );
  }
}
