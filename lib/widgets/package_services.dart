import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/screens/service_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackageServices extends StatefulWidget {
  const PackageServices({
    Key? key,
    required this.name,
    required this.id,
  }) : super(key: key);

  // * package name
  final String name;
  // * package id
  final String id;

  @override
  State<PackageServices> createState() => _PackageServicesState();
}

class _PackageServicesState extends State<PackageServices> {
  // -- styling
  final checkoutBtnStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    ),
  );

  var items = [];
  double totalCost = 0;
  bool foundItems = false;
  bool totalPriceCounted = false;
  bool foundError = false;

  // ! shared-preferences, to get [token] of the user stored on device
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

  // ! to remove package after placing order
  Future<void> _removePackage() async {
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
      } else {
        // ! err
      }
    } catch (err) {
      // ! err
    }
  }

  bool isPlacingOrder = false;

  // ! for placing order
  Future<void> placeOrder() async {
    // get url from EndPoint
    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/placeOrder';

    // ! show loading spinner
    setState(() {
      isPlacingOrder = true;
    });

    try {
      // ! converting to form-data
      final formData = FormData.fromMap({
        'packageId': widget.id,
        'email': userEmail,
        'date_created': DateTime.now().toString(),
        'token': apiToken,
        'price': totalCost,
      });

      // ! sending POST req
      final response = await Dio().post(
        url,
        data: formData,
      );

      if (response.toString() == 'placed') {
        // ! remove package if order is placed;
        await _removePackage();
        // *

        // ! if order is placed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '👍 Order placed successfully.\nPackage "' +
                  widget.name +
                  '" removed.',
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
        // ! 'placed' is not returned
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠ Error placing order'),
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
      // *

    } catch (err) {
      // ! err
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Could not place order'),
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

    // ! stop-loading spinner
    setState(() {
      isPlacingOrder = false;
    });

    // ! closing modal-sheet
    Navigator.pop(context);
  }

  Future<void> getPackageItems() async {
    // get url from EndPoint
    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/serviceFromPackage/';
    // adding id of the package
    url += widget.id + '/';
    // adding token
    url += apiToken;

    try {
      final response = await Dio().get(url);

      final jsonData = response.data as List;

      // ! (checking mounted), to see that if the widget is still in the tree or not
      if (mounted) {
        setState(() {
          items = jsonData;
          foundItems = true;
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

    // ! count total price
    _countTotal();
  }

  void _countTotal() {
    for (var i = 0; i < items.length; i++) {
      totalCost += double.parse(items[i]['price'].toString()) *
          int.parse(items[i]['count'].toString());
    }

    setState(() {
      totalPriceCounted = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // ! get api token
    // ! then get package items
    loadTokenAndItems();
  }

  Future<void> loadTokenAndItems() async {
    await loadApiTokenAndEmail();
    getPackageItems();
  }

  @override
  Widget build(BuildContext context) {
    var url = Provider.of<EndPoint>(context, listen: false).imageEndpoint;

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

        // child
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ! package-name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // * package name
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // * checkout btn
                ClipRRect(
                  child: ElevatedButton(
                    style: checkoutBtnStyle,
                    onPressed: isPlacingOrder == false ? placeOrder : null,
                    child: isPlacingOrder == false
                        ? const Text('Checkout')
                        : const SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
              ],
            ),

            // ! white-space
            const SizedBox(height: 10),

            // ! divider
            const Divider(color: Colors.black),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Item'),
                  Text('Quantity'),
                ],
              ),
            ),

            // ! divider
            const Divider(color: Colors.black),

            // ! items
            if (foundItems)
              SizedBox(
                // height
                height: 250,
                // child
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return ListTile(
                      // * onTap
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServicePage(
                              sId: item['id'],
                              sSeller: item['s_name'],
                              sSellerEmail: item['email'],
                              sName: item['name'],
                              sDescription: item['description'],
                              sRating: double.parse(item['rating'].toString()),
                              sPrice: double.parse(item['price'].toString()),
                              imageAddress: item['image_title'],
                            ),
                          ),
                        );
                      },
                      // * image
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          url + item['image_title'],
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                        ),
                      ),
                      // * title
                      title: Text(item['name']),
                      // * price
                      subtitle: Text('Rs. ' + item['price'].toString()),
                      // * quantity btn
                      trailing: Text(
                        item['count'].toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  },
                ),
              )
            else
              const SizedBox(
                height: 250,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            // ! Total
            const Divider(color: Colors.black),

            Container(
              // padding
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              // width
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  if (totalPriceCounted)
                    Text(
                      totalCost.toString(),
                    )
                  else
                    const SizedBox(
                      child: CircularProgressIndicator(),
                      height: 10,
                      width: 10,
                    ),
                ],
              ),
            ),

            const Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
