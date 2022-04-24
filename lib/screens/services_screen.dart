import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key, required this.cName}) : super(key: key);

  // category name
  final String cName;

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  // api endpoint
  // final url = 'http://10.0.2.2:3000/event_planner/api/';
  final url = 'http://192.168.1.39:3000/event_planner/api/';

  void getData() async {
    try {
      final response = await get(Uri.parse(url + widget.cName.toLowerCase()));
      final jsonData = jsonDecode(response.body) as List;

      setState(() {});
    } catch (err) {}
  }

  @override
  void initState() {
    super.initState();
    // geting specific category data
    getData();
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
      body: Center(
        child: Text(widget.cName),
      ),
    );
  }
}
