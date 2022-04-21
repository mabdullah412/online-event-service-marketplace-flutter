import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({Key? key, required this.cName}) : super(key: key);

  // category name
  final String cName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF333333),
        ),
        title: Text(cName),
      ),
      body: Center(
        child: Text(cName),
      ),
    );
  }
}
