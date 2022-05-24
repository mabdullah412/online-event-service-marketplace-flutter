import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/user_mode.dart';

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

  String uploadStatus = 'Upload status will be displayed here';
  File? _storedImage;

  Future<void> _uploadFile() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      // maxHeight: 600,
    );

    if (imageFile == null) {
      return;
    }

    setState(() {
      _storedImage = File(imageFile.path);
    });

    try {
      print('error before formData');

      // ! converting to formdata
      FormData formData = FormData.fromMap({
        'fileSender': 'abdullah',
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.name,
        ),
      });

      print('error after formData');

      // ! sending POST request
      final response = Dio().post(
        'http://192.168.94.84:3000/event_planner/api/testingUploads',
        data: formData,
      );

      print(response.toString());
    } catch (err) {
      print('--------------------------------------------------------');
      print('error');
      print('--------------------------------------------------------');
    }
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

          // ! TEMPORARY: send-file
          const SizedBox(height: 50),

          ElevatedButton(
            onPressed: _uploadFile,
            child: const Text('Send File'),
          ),

          const SizedBox(height: 50),

          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.indigo,
              ),
            ),
            child: _storedImage != null
                ? Image.file(
                    _storedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : const Text(
                    'Plz select an image',
                    textAlign: TextAlign.center,
                  ),
            alignment: Alignment.center,
          ),

          const SizedBox(height: 50),

          Text(uploadStatus),
        ],
      ),
    );
  }
}
