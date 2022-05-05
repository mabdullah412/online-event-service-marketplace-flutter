import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/widgets/service_tile.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key, required this.cName}) : super(key: key);

  // category name
  final String cName;

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
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
        title: Text(widget.cName),
      ),
      body: Container(
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
            ServiceTile(),
          ],
        ),
      ),
    );
  }
}
