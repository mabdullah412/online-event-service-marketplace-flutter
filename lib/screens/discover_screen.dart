import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:semester_project/screens/services_screen.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> {
  final url = 'http://10.0.2.2:3000/event_planner/api/categories';
  // final url = 'http://192.168.1.84:3000/event_planner/api/categories';

  var allCategories = [];
  var categories = [];

  void getCategories() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;

      setState(() {
        allCategories = jsonData;
        categories = allCategories;
      });
    } catch (err) {}
  }

  @override
  void initState() {
    super.initState();
    // getting categories
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
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
          // ListView
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
                            cName: category['title'],
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

    setState(() {
      categories = suggestion;
    });
  }
}