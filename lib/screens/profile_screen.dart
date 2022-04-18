import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: const Text('Hello'),
    );
  }
}
