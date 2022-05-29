import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/widgets/create_package.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToPackage extends StatefulWidget {
  const AddToPackage({
    Key? key,
    required this.sId,
    required this.sName,
  }) : super(key: key);

  // * service id
  final String sId;
  // * service name
  final String sName;

  @override
  State<AddToPackage> createState() => _AddToPackageState();
}

class _AddToPackageState extends State<AddToPackage> {
  // add button style
  final setBtnStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
  );

  // * create package
  void _createPackage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const CreatePackage();
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

  // ! shared-preferences, to get [token and email] of the user stored on device
  late SharedPreferences localUserData;
  String apiToken = '';
  String userEmail = '';

  Future<void> loadApiTokenAndEmail() async {
    localUserData = await SharedPreferences.getInstance();
    String storedToken = localUserData.getString('ep_token') as String;
    String storedEmail = localUserData.getString('ep_email') as String;

    setState(() {
      apiToken = storedToken;
      userEmail = storedEmail;
    });
  }

  // ! packages data
  var packages = [];
  bool foundPackages = false;
  bool foundError = false;
  bool isLoadingPackages = true;

  // ! loading services
  Future<void> getPackages() async {
    // * if user refreshes, go back to loading screen
    setState(() {
      isLoadingPackages = true;
    });

    // get url from EndPoint
    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/package/';
    url += userEmail + '/';
    url += apiToken;

    try {
      final response = await Dio().get(url);
      final jsonData = response.data as List;

      // ! (checking mounted), to see that if the widget is still in the tree or not
      // * if responses are empty
      if (mounted) {
        setState(() {
          isLoadingPackages = false;
          packages = jsonData;
          foundPackages = true;
        });
      }
    } catch (err) {
      // ! (checking mounted), to see that if the widget is still in the tree or not
      if (mounted) {
        setState(() {
          foundError = true;
        });
      }
    }
  }

  Future<void> loadInOrder() async {
    await loadApiTokenAndEmail();
    getPackages();
  }

  // * add to package
  Future<void> _addToPackage(String packageId, String packageName) async {
    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/addServiceToPackage';

    try {
      // ! converting to formData
      final formData = FormData.fromMap({
        'packageId': packageId,
        'serviceId': widget.sId,
        'token': apiToken,
      });

      // ! sending POST request
      final response = await Dio().post(
        url,
        data: formData,
      );

      // ! server response
      if (response.toString() == 'added') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '👍 ' + widget.sName + ' added to ' + packageName + ' package.',
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            duration: const Duration(seconds: 2),
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
      // !

    } catch (err) {
      // ! err
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Could not add service to package'),
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

    // ! close the modal sheet
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    loadInOrder();
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
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Add to package',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: ElevatedButton.icon(
                onPressed: () {
                  _createPackage(context);
                },
                label: const Text('create'),
                icon: const Icon(PhosphorIcons.plusBold),
                style: setBtnStyle,
              ),
            ),

            // ! divider
            const Divider(),

            if (isLoadingPackages == false)
              TextButton.icon(
                onPressed: getPackages,
                icon: const Icon(PhosphorIcons.arrowCounterClockwiseBold),
                label: const Text('Refresh'),
              ),

            // ! divider
            const Divider(),

            // ! Packages
            // ! while loading packeges
            if (isLoadingPackages)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            // ! after loading >> if empty
            else if (packages.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: const [
                    Text(
                      'You have no packages. Create a package to add services for buying.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              )
            // ! after loading >> if not empty
            else
              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: packages.length,
                  itemBuilder: (context, index) {
                    final package = packages[index];
                    return ListTile(
                      leading: const Icon(PhosphorIcons.package),
                      title: Text(package['name']),
                      onTap: () {
                        _addToPackage(package['id'], package['name']);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
