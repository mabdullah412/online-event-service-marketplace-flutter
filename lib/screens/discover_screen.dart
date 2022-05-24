import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/models/user_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services_page.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> {
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

  var allCategories = [];
  var categories = [];
  bool foundCategories = false;
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

  Future<void> getCategories() async {
    // get url from EndPoint
    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'category/';
    url += apiToken;

    try {
      // final response = await get(Uri.parse(url));
      final response = await Dio().get(url);

      final jsonData = response.data as List;

      // ! (checking mounted), to see that if the widget is still in the tree or not
      if (mounted) {
        setState(() {
          allCategories = jsonData;
          categories = allCategories;
          foundCategories = true;
        });

        // gotCategoriesOnce = true;
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
    // ! get api token
    // ! then get categories
    loadTokenAndCategories();
  }

  Future<void> loadTokenAndCategories() async {
    await loadApiToken();
    await getCategories();
  }

  @override
  Widget build(BuildContext context) {
    // ! getting seller mode status
    bool _sellerMode = Provider.of<UserMode>(context, listen: false).sellerMode;

    return Container(
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
      // child
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // heading
          const Text(
            'Browse',
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          // sub-heading
          const Text(
            'Browse service that best suit your event.',
            style: TextStyle(
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          // search bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(15, 0, 0, 0),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search service',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: searchBook,
            ),
          ),

          const SizedBox(height: 30),

          // categories title
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 10),

          // ! message for SELLER MODE
          if (_sellerMode)
            Container(
              // padding
              padding: const EdgeInsets.all(20),
              // constraints
              width: MediaQuery.of(context).size.width,
              // child
              child: const Text(
                '⚠ You can only browse services while in seller mode. Exit seller mode to buy services.',
              ),
              // decoration
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: containerShadow,
                borderRadius: containerRadius,
              ),
            ),

          if (_sellerMode) const SizedBox(height: 10),

          // ListView
          if (foundCategories)
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServicesPage(
                              cTitle: category['title'],
                              cDescription: category['description'],
                              cImageTitle: category['image_title'],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFF333333),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/icons/categories/' +
                                  category['image_title'],
                            ),
                          ),
                        ),
                        title: Text(category['title']),
                        subtitle: Text(category['description']),
                      ),
                    ),
                  );
                },
              ),
            )
          // * if error not found, display spinner
          else if (foundError == false)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          // * if error is found, remove spinner and display error msg.
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/illustrations/page_not_found.png',
                      width: 150,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Error fetching results.',
                      style: TextStyle(
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void searchBook(String query) {
    final suggestion = allCategories.where((cat) {
      final categoryTitle = cat['title'].toLowerCase();
      final input = query.toLowerCase();

      return categoryTitle.contains(input);
    }).toList();

    // ! (checking mounted), to see that if the widget is still in the tree or not
    if (mounted) {
      setState(() {
        categories = suggestion;
      });
    }
  }
}
