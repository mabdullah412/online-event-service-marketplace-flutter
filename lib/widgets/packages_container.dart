import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/widgets/create_package.dart';
import 'package:semester_project/widgets/package_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackagesContainer extends StatefulWidget {
  const PackagesContainer({Key? key}) : super(key: key);

  @override
  State<PackagesContainer> createState() => _PackagesContainerState();
}

class _PackagesContainerState extends State<PackagesContainer> {
  // styling
  final lightTextStyle = const TextStyle(
    color: Color(0xFF777777),
  );

  // heading-text
  final headingTextStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  // * modal sheet for create-package
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

  // ! loading packages
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

  @override
  void initState() {
    super.initState();
    loadInOrder();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // * width
      width: MediaQuery.of(context).size.width,
      // * height
      height: 350,
      // * child
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ! heading
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // * text
              Text(
                'Packages',
                style: headingTextStyle,
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // * refresh
                  IconButton(
                    onPressed: getPackages,
                    icon: const Icon(PhosphorIcons.arrowCounterClockwiseBold),
                  ),
                  // * add
                  IconButton(
                    onPressed: () {
                      _createPackage(context);
                    },
                    icon: const Icon(PhosphorIcons.plus),
                  ),
                ],
              ),
            ],
          ),

          // ! data
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
            noPackagesPlaceholder(context)
          // ! after loading >> if not empty
          else
            SizedBox(
              height: 300,
              // * listview builder
              child: ListView.builder(
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  final package = packages[index];
                  return PackageItem(
                    name: package['name'],
                    id: package['id'],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget noPackagesPlaceholder(BuildContext context) {
    return SizedBox(
      // * width
      width: MediaQuery.of(context).size.width,
      // * child
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ! space
          const SizedBox(height: 60),

          // ! image
          Image.asset(
            'assets/illustrations/no_packages.png',
            width: 100,
          ),

          // ! space
          const SizedBox(height: 30),

          // ! text
          Text(
            'You have created no packages yet',
            style: lightTextStyle,
          ),

          // ! create button
          TextButton(
            child: const Text('Create a package'),
            onPressed: () {
              _createPackage(context);
            },
          ),
        ],
      ),
    );
  }
}
