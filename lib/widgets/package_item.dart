import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/widgets/package_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackageItem extends StatefulWidget {
  const PackageItem({
    Key? key,
    required this.name,
    required this.id,
  }) : super(key: key);

  // * package name
  final String name;
  // * package id
  final String id;

  @override
  State<PackageItem> createState() => _PackageItemState();
}

class _PackageItemState extends State<PackageItem> {
  // container-decorations
  final containerRadius = BorderRadius.circular(10);

  // 2. box-shadow
  final containerShadow = const [
    BoxShadow(
      color: Color.fromARGB(15, 0, 0, 0),
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];

  // ! for viewing items in the package
  void _seeItems(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PackageServices(
          id: widget.id,
          name: widget.name,
        );
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

  // ! shared-preferences, to get [token] of the user stored on device
  late SharedPreferences localUserData;
  String apiToken = '';

  Future<void> loadApiToken() async {
    localUserData = await SharedPreferences.getInstance();
    String storedToken = localUserData.getString('ep_token') as String;

    setState(() {
      apiToken = storedToken;
    });
  }

  bool removingPackage = false;

  Future<void> _removePackage() async {
    // ! show loading spinner, in place of delete btn
    setState(() {
      removingPackage = true;
    });

    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/removePackage';

    try {
      // ! converting to formData
      final formData = FormData.fromMap({
        'packageId': widget.id,
        'token': apiToken,
      });

      final response = await Dio().post(
        url,
        data: formData,
      );

      if (response.toString() == 'removed') {
        // ! removed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('👍 Package removed successfully'),
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
        // ! err
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠ Error deleting package'),
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
    } catch (err) {
      // ! err
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Error deleting package'),
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

    setState(() {
      removingPackage = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // * laoding api token
    loadApiToken();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width
      width: MediaQuery.of(context).size.width,
      // margin
      margin: const EdgeInsets.symmetric(vertical: 5),
      // decoration
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: containerShadow,
        borderRadius: containerRadius,
      ),
      // child
      child: ListTile(
        // * icon
        leading: const Icon(PhosphorIcons.package),
        // * p-name
        title: Text(widget.name),
        // * delete-btn
        trailing: removingPackage == false
            ? IconButton(
                onPressed: _removePackage,
                icon: const Icon(
                  PhosphorIcons.trashSimple,
                  color: Colors.red,
                ),
              )
            : const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
        // * onTap
        onTap: () {
          _seeItems(context);
        },
      ),
    );
  }
}
