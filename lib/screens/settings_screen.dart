import 'package:flutter/material.dart';
import 'package:semester_project/widgets/edit_endpoint.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
              TextButton(
                onPressed: () {
                  _editEndpoint(context);
                },
                child: const ListTile(
                  title: Text('Edit Endpoint'),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
