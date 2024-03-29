import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/models/user_mode.dart';
import 'package:semester_project/screens/create_service_page.dart';
import 'package:semester_project/screens/service_page.dart';
import 'package:semester_project/widgets/create_package.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // -- styling --
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
  // primary-text-color
  final primaryTextColor = const Color(0xFF333333);
  // button-style
  final packageButtonStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
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

  // ! shared-preferences, to get [username] of the user stored on device
  String username = '';
  String apiToken = '';
  String userEmail = '';

  late SharedPreferences localUserData;
  Future loadUsernameTokenEmail() async {
    localUserData = await SharedPreferences.getInstance();
    String storedName = localUserData.getString('ep_username') as String;
    String storedToken = localUserData.getString('ep_token') as String;
    String storedEmail = localUserData.getString('ep_email') as String;

    setState(() {
      username = storedName;
      apiToken = storedToken;
      userEmail = storedEmail;
    });
  }

  // ! get my services
  var services = [];
  bool foundServices = false;
  bool foundError = false;

  Future<void> getMyServices() async {
    // get url from EndPoint
    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/myservices/';
    // adding id of the order
    url += userEmail + '/';
    // adding token
    url += apiToken;

    try {
      final response = await Dio().get(url);

      final jsonData = response.data as List;

      // ! (checking mounted), to see that if the widget is still in the tree or not
      if (mounted) {
        setState(() {
          services = jsonData;
          foundServices = true;
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

  bool isRemovingService = false;

  Future<void> _removeService(String serviceId) async {
    // ! get url from EndPoint
    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/removeService';

    try {
      // ! converting to formData
      final formData = FormData.fromMap({
        'serviceId': serviceId,
        'token': apiToken,
      });

      final response = await Dio().post(url, data: formData);

      if (response.toString() == 'removed') {
        // ! err
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('👍 Service removed successfully'),
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
            content: Text('⚠ Could not remove service'),
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
          content: Text('⚠ Error calling request'),
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
  }

  // ! sales data
  int salesCount = 0;
  bool foundCount = false;
  bool isLoadingSales = true;

  // ! load sales
  Future<void> getSalesCount() async {
    // * if user refreshes, go back to loading screen
    setState(() {
      isLoadingSales = true;
    });

    // get url from EndPoint
    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/salesCount/';
    url += userEmail + '/';
    url += apiToken;

    try {
      final response = await Dio().get(url);
      salesCount = response.data['COUNT(*)'];

      // ! (checking mounted), to see that if the widget is still in the tree or not
      if (mounted) {
        setState(() {
          foundCount = true;
        });
      }
      // *

    } catch (err) {
      // ! (checking mounted), to see that if the widget is still in the tree or not
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadSPAndData();
  }

  Future<void> loadSPAndData() async {
    await loadUsernameTokenEmail();
    getSalesCount();
    getMyServices();
  }

  @override
  Widget build(BuildContext context) {
    // ! getting seller mode status
    bool _sellerMode = Provider.of<UserMode>(context, listen: false).sellerMode;
    var url = Provider.of<EndPoint>(context, listen: false).imageEndpoint;

    return SingleChildScrollView(
      child: Container(
        // width
        width: MediaQuery.of(context).size.width,
        // bg-color
        color: const Color(0xFFF8F8F8),
        // padding
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 30,
          right: 20,
          left: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * welcome message
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, Good Morning',
                  style: TextStyle(
                    color: primaryTextColor,
                  ),
                ),
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor,
                  ),
                ),
              ],
            ),

            if (_sellerMode == false) const SizedBox(height: 20),

            // * carousel
            if (_sellerMode == false)
              Container(
                // constraints
                width: MediaQuery.of(context).size.width,

                // height
                height: 200,

                // padding
                padding: const EdgeInsets.all(15),

                // child
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Explore Services',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Find the services that best suit your event.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // decoration
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: containerShadow,
                  borderRadius: containerRadius,
                  image: const DecorationImage(
                    image: AssetImage('assets/cover_images/cover_image3.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            if (_sellerMode) const SizedBox(height: 20),

            // ! Dashboard
            if (_sellerMode)
              Container(
                // padding
                padding: const EdgeInsets.all(20),
                // constraints
                width: MediaQuery.of(context).size.width,
                // decoration
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: containerShadow,
                  borderRadius: containerRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: CircleAvatar(
                        child: Text(salesCount.toString()),
                        backgroundColor: const Color(0xFF333333),
                      ),
                      title: const Text('Order(s) waiting to be completed'),
                    ),
                    // const SizedBox(height: 100),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // ! Create service
            if (_sellerMode)
              Container(
                // padding
                padding: const EdgeInsets.all(20),
                // constraints
                width: MediaQuery.of(context).size.width,
                // decoration
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: containerShadow,
                  borderRadius: containerRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sell a service',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Have services thay you would like to sell? Go to the profile page and turn on seller mode.',
                      style: TextStyle(
                        color: Color(0xFF777777),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CreateServicePage(),
                            ),
                          );
                        },
                        child: const Text('Create'),
                        style: packageButtonStyle,
                      ),
                    )
                  ],
                ),
              ),

            if (_sellerMode) const SizedBox(height: 20),

            // ! check your provided services
            if (_sellerMode)
              Container(
                // padding
                padding: const EdgeInsets.all(20),
                // constraints
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
                    Text(
                      'My Services',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ! if services are found
                    if (services.isEmpty)
                      const Text(
                        'You haven\'t provided any services yet.',
                        style: TextStyle(
                          color: Color(0xFF777777),
                        ),
                      )
                    else if (foundServices)
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final service = services[index];

                            return ListTile(
                              // * on Tap
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ServicePage(
                                      sId: service['id'],
                                      sSeller: service['s_name'],
                                      sSellerEmail: service['email'],
                                      sName: service['name'],
                                      sDescription: service['description'],
                                      sRating: double.parse(
                                          service['rating'].toString()),
                                      sPrice: double.parse(
                                          service['price'].toString()),
                                      imageAddress: service['image_title'],
                                      sLocation: service['location'],
                                    ),
                                  ),
                                );
                              },

                              // * image
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  url + service['image_title'],
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                ),
                              ),

                              // * title
                              title: Text(service['name']),

                              // * price
                              subtitle: Text(
                                'Rs. ' + service['price'].toString(),
                              ),

                              // * quantity
                              trailing: IconButton(
                                onPressed: () async {
                                  // ! show loading spinner
                                  setState(() {
                                    isRemovingService = true;
                                  });

                                  await _removeService(service['id']);

                                  // ! stop-showing loading spinner
                                  setState(() {
                                    isRemovingService = false;
                                  });
                                },
                                icon: isRemovingService == false
                                    ? const Icon(
                                        PhosphorIcons.trashBold,
                                        color: Colors.red,
                                      )
                                    : const CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      )
                    // ! if services are found, but are empty list

                    else
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),

            // * create a package
            if (_sellerMode == false)
              Container(
                // padding
                padding: const EdgeInsets.all(20),
                // constraints
                width: MediaQuery.of(context).size.width,
                // child
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a package',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Create your own custom packages by adding the services you desire and pay for the whole package in one click.',
                      style: TextStyle(
                        color: Color(0xFF777777),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _createPackage(context);
                        },
                        child: const Text('Create package'),
                        style: packageButtonStyle,
                      ),
                    ),
                  ],
                ),
                // decoration
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: containerShadow,
                  borderRadius: containerRadius,
                ),
              ),

            const SizedBox(height: 20),

            // * sell services container
            if (_sellerMode == false)
              Container(
                // padding
                padding: const EdgeInsets.all(20),
                // constraints
                width: MediaQuery.of(context).size.width,
                // decoration
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: containerShadow,
                  borderRadius: containerRadius,
                ),
                // child
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Become a seller',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Have services thay you would like to sell? Go to the profile page and turn on seller mode.',
                      style: TextStyle(
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
