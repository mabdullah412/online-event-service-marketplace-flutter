import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateServicePage extends StatefulWidget {
  const CreateServicePage({Key? key}) : super(key: key);

  @override
  State<CreateServicePage> createState() => _CreateServicePageState();
}

class _CreateServicePageState extends State<CreateServicePage> {
  // * styling
  // * 1. border-radius
  final containerRadius = BorderRadius.circular(10);
  // * 2. box-shadow
  final containerShadow = const [
    BoxShadow(
      color: Color.fromARGB(15, 0, 0, 0),
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];
  // * text-Field borderRadius
  final textFieldBorderRadius = const OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(Radius.circular(50)),
  );

  // ! form-values-and-controllers
  String selectedcategory = 'Decoration';
  var serviceNameController = TextEditingController();
  var serviceDescriptionController = TextEditingController();
  var serviceLocationController = TextEditingController();
  var servicePriceController = TextEditingController();

  bool noImages = true;
  File? selectedImage;
  XFile? selectedImageFile;

  // ! shared-preferences, to get [token] of the user stored on device
  late SharedPreferences localUserData;
  String apiToken = '';
  String userEmail = '';

  Future<void> _addPictures(int mode) async {
    // * mode 0 = for camera
    // * mode 0 = for gallery

    final picker = ImagePicker();

    if (mode == 0) {
      final imageFile = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (imageFile == null) {
        return;
      }

      setState(() {
        selectedImage = File(imageFile.path);
        selectedImageFile = imageFile;
        noImages = false;
      });
    } else if (mode == 1) {
      final imageFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (imageFile == null) {
        return;
      }

      setState(() {
        selectedImage = File(imageFile.path);
        selectedImageFile = imageFile;
        noImages = false;
      });
    }
  }

  bool isCreatingService = false;

  Future<void> _createService() async {
    final serviceNameText = serviceNameController.text;
    final serviceDescriptionText = serviceDescriptionController.text;
    final serviceLocationText = serviceLocationController.text;
    final servicePriceText = servicePriceController.text;

    // ! close keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    // ! if anything is added, return
    if (noImages == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Please add an image'),
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
    } else if (serviceNameText == '') {
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
    } else if (serviceDescriptionText == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Desctiption cannot be empty'),
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
    } else if (serviceLocationText == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Location cannot be empty'),
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
    } else if (servicePriceText == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Price cannot be empty'),
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

    // ! show loading spinner
    setState(() {
      isCreatingService = true;
    });

    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/addService';

    try {
      // ! converting to formData
      final formData = FormData.fromMap({
        // 'id': '', => assigned on the server
        'email': userEmail,
        'name': serviceNameText,
        'description': serviceDescriptionText,
        'price': servicePriceText,
        'location': serviceLocationText,
        'category': selectedcategory,
        'date_created': DateTime.now(),
        'image': await MultipartFile.fromFile(
          selectedImageFile!.path,
          filename: selectedImageFile!.name,
        ),
        'token': apiToken,
      });

      // ! sending POST request
      final response = await Dio().post(
        url,
        data: formData,
      );

      // *
      if (response.toString() == 'created') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service added successfully'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            duration: Duration(seconds: 2),
          ),
        );
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
          content: Text('⚠ Could not add service'),
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

    // ! stop showing loading spinner
    setState(() {
      isCreatingService = false;
    });

    // ! pop screen
    Navigator.pop(context);
  }

  Future<void> loadApiTokenAndEmail() async {
    localUserData = await SharedPreferences.getInstance();
    String storedToken = localUserData.getString('ep_token') as String;
    String storedEmail = localUserData.getString('ep_email') as String;

    setState(() {
      apiToken = storedToken;
      userEmail = storedEmail;
    });
  }

  @override
  void initState() {
    super.initState();
    // * laoding api token
    loadApiTokenAndEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF333333),
        ),
        title: const Text('Create a service'),
      ),
      body: SingleChildScrollView(
        child: Container(
          // width
          width: MediaQuery.of(context).size.width,
          // bg-color
          color: const Color(0xFFF8F8F8),
          // padding
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 40,
            right: 20,
            left: 20,
          ),
          child: Column(
            children: [
              // * form-container
              Container(
                // padding
                padding: const EdgeInsets.all(20),
                // width
                width: MediaQuery.of(context).size.width,
                // decoration
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: containerShadow,
                  borderRadius: containerRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // * images
                    if (noImages)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 100,
                          color: const Color(0xFFF8F8F8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  _addPictures(0);
                                },
                                icon: const Icon(PhosphorIcons.aperture),
                                label: const Text('Capture Image'),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  _addPictures(1);
                                },
                                icon: const Icon(PhosphorIcons.image),
                                label: const Text('Add Image from gallery'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // const SizedBox(height: 10),
                          TextButton(
                            child: const Text('Clear Image'),
                            onPressed: () {
                              setState(() {
                                noImages = true;
                              });
                            },
                          ),
                        ],
                      ),

                    const SizedBox(height: 20),

                    // * text
                    const Text(
                      'Enter service details',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // * Service name
                    TextField(
                      controller: serviceNameController,
                      decoration: InputDecoration(
                        border: textFieldBorderRadius,
                        hintText: 'Service name',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8F8F8),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // * Service price
                    TextField(
                      controller: servicePriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: textFieldBorderRadius,
                        hintText: 'Price',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8F8F8),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // * Service location
                    TextField(
                      controller: serviceLocationController,
                      decoration: InputDecoration(
                        border: textFieldBorderRadius,
                        hintText: 'Location',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8F8F8),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // * Service description
                    TextField(
                      controller: serviceDescriptionController,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        hintText: 'Service description',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF8F8F8),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // * category
                    const Text('Select a category'),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton<String>(
                        value: selectedcategory,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        elevation: 1,
                        onChanged: (newVal) {
                          setState(() {
                            selectedcategory = newVal!;
                          });
                        },
                        items: <String>[
                          'Decoration',
                          'Car Rental',
                          'Catering',
                          'Halls',
                          'Photography',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // * submit button
                    ElevatedButton(
                      onPressed:
                          isCreatingService == false ? _createService : null,
                      child: isCreatingService == false
                          ? const Text('Create')
                          : const SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
