import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/widgets/service_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key, required this.cTitle}) : super(key: key);

  // category title
  final String cTitle;

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

  // ! services data
  var services = [];
  bool foundServices = false;
  bool foundError = false;

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

  // ! loading services
  Future<void> getServices() async {
    // get url from EndPoint
    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/service/';
    // * adding name of the category
    url += widget.cTitle + '/';
    // * adding token
    url += apiToken;

    try {
      final response = await Dio().get(url);
      final jsonData = response.data as List;

      // ! (checking mounted), to see that if the widget is still in the tree or not
      // * if responses are empty
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

  @override
  void initState() {
    super.initState();
    // geting specific category data
    loadTokenAndData();
  }

  Future<void> loadTokenAndData() async {
    await loadApiToken();
    await getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF333333),
        ),
        title: Text(widget.cTitle),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(PhosphorIcons.sliders),
          ),
        ],
      ),
      body: Container(
        // width
        width: MediaQuery.of(context).size.width,
        // bg-color
        color: const Color(0xFFF8F8F8),
        // padding
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: displayData(),
      ),
    );
  }

  // ! widget to display data
  Widget displayData() {
    if (foundError) {
      return const Center(
        child: Text('Error fetching results'),
      );
    }
    // ! if services are empty
    else if (services.isEmpty) {
      return const Center(
        child: Text('EMPTY'),
      );
    }
    // ! if data found
    else if (foundServices) {
      return ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];

          return ServiceTile(
            sId: service['id'],
            sSeller: service['s_name'],
            sSellerEmail: service['email'],
            sName: service['name'],
            sPrice: double.parse(service['price'].toString()),
            sRating: double.parse(service['rating'].toString()),
            sDescription: service['description'],
            imageAddress: service['image_title'],
          );
        },
      );
    }

    // ! spinner
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}



// ! filter container
// Container(
//                 // width
//                 width: MediaQuery.of(context).size.width,
//                 // margin
//                 margin: const EdgeInsets.only(bottom: 20),
//                 // decoration
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: containerShadow,
//                   borderRadius: containerRadius,
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 25,
//                   horizontal: 25,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const Text(
//                       'Filter services',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),

//                     const SizedBox(height: 15),

//                     // * search service
//                     const TextField(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.all(Radius.circular(50)),
//                         ),
//                         hintText: 'Search service',
//                         prefixIcon: Icon(PhosphorIcons.magnifyingGlass),
//                         filled: true,
//                         fillColor: Color(0xFFF8F8F8),
//                       ),
//                     ),

//                     const SizedBox(height: 15),

//                     // * apply filter btn
//                     ElevatedButton(
//                       onPressed: () {},
//                       child: const Text('Apply'),
//                       style: ButtonStyle(
//                         shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),