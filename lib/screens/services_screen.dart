import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/widgets/service_tile.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({
    Key? key,
    required this.cTitle,
    required this.cDescription,
    required this.cImageTitle,
  }) : super(key: key);

  // category title
  final String cTitle;
  // category description
  final String cDescription;
  // category image_title
  final String cImageTitle;

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  // * -- styling --
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

  // void getData() async {
  //   // api endpoint
  //   final url = Provider.of<EndPoint>(context, listen: false).endpoint;

  //   try {
  //     final response = await get(Uri.parse(url + widget.cName.toLowerCase()));
  //     final jsonData = jsonDecode(response.body) as List;

  //     setState(() {});
  //   } catch (err) {}
  // }

  @override
  void initState() {
    super.initState();
    // geting specific category data
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF333333),
        ),
        title: Text(widget.cTitle),
      ),
      body: SingleChildScrollView(
        child: Container(
          // width
          width: MediaQuery.of(context).size.width,
          // bg-color
          color: const Color(0xFFF8F8F8),
          // padding
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          child: Column(
            children: [
              // * filter
              Container(
                // width
                width: MediaQuery.of(context).size.width,
                // margin
                margin: const EdgeInsets.only(bottom: 20),
                // decoration
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: containerShadow,
                  borderRadius: containerRadius,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Filter services',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // * search service
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        hintText: 'Search service',
                        prefixIcon: Icon(PhosphorIcons.magnifyingGlass),
                        filled: true,
                        fillColor: Color(0xFFF8F8F8),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // * apply filter btn
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Apply'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // * divider
              const Divider(color: Color(0xFF999999)),
              const SizedBox(height: 20),

              // * Tutorial
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // * bookmark button
                  Column(
                    children: const [
                      CircleAvatar(
                        child: Icon(
                          PhosphorIcons.bookmarkSimple,
                          color: Color(0xFFFFFFFF),
                        ),
                        radius: 20,
                        backgroundColor: Color(0xFF333333),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Bookmark\nbutton',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  // * add to package button
                  Column(
                    children: const [
                      CircleAvatar(
                        child: Icon(
                          PhosphorIcons.listPlus,
                          color: Color(0xFFFFFFFF),
                        ),
                        radius: 20,
                        backgroundColor: Color(0xFF333333),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Add to Package\nbutton',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),

              // * divider
              const SizedBox(height: 20),
              const Divider(color: Color(0xFF999999)),
              const SizedBox(height: 20),

              // * service tiles
              ServiceTile(
                sSeller: 'Muhammad Abdullah',
                sName: 'BMW shadi car',
                sPrice: 8000,
                sRating: 4,
                sDescription:
                    'Get a high end car for your Barat. You will feel very comfortable in the car',
                imageAddress: 'assets/test_images/car.jpg',
              ),
              ServiceTile(
                sSeller: 'Hamza Hall Rentals',
                sName: 'Plant wedding hall',
                sPrice: 22000,
                sRating: 4.9,
                sDescription:
                    'Get a high end car for your Barat. You will feel very comfortable in the car',
                imageAddress: 'assets/test_images/plants.jpg',
              ),
              ServiceTile(
                sSeller: 'Police car services',
                sName: 'Porsche black car',
                sPrice: 10000,
                sRating: 4.5,
                sDescription:
                    'Get a high end car for your Barat. You will feel very comfortable in the car',
                imageAddress: 'assets/test_images/car2.jpg',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
