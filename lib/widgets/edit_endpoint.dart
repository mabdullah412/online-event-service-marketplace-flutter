import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';

class EditEndpoint extends StatefulWidget {
  const EditEndpoint({Key? key}) : super(key: key);

  @override
  State<EditEndpoint> createState() => _EditEndpointState();
}

class _EditEndpointState extends State<EditEndpoint> {
  // form controller
  final _endpointController = TextEditingController();

  final setBtnStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
  );

  // set endpoint
  void _setData() {
    if (_endpointController.text.isEmpty) {
      // close the modal after data is entered
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Endpoint not set'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          duration: Duration(seconds: 2),
        ),
      );
      // close the modal sheet
      Navigator.of(context).pop();
      return;
    }

    final endpoint = _endpointController.text;
    Provider.of<EndPoint>(context, listen: false).setEndpoint(endpoint);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('👍 Endpoint set successfully'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        duration: Duration(seconds: 2),
      ),
    );

    // close the modal sheet after data is entered
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // width
        width: MediaQuery.of(context).size.width,
        // padding
        padding: EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 40,
        ),
        // child
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Set new endpoint',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  _setData();
                },
                child: const Text('Set'),
                style: setBtnStyle,
              ),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Endpoint'),
              controller: _endpointController,
              onSubmitted: (_) => _setData(),
            ),
          ],
        ),
      ),
    );
  }
}
