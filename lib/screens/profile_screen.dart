import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: MediaQuery.of(context).size.width,
            child: const ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              leading: CircleAvatar(
                child: Icon(PhosphorIcons.userBold),
                backgroundColor: Color(0xFF333333),
                radius: 30,
              ),
              title: Text('Muhammad Abdullah'),
            ),
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
