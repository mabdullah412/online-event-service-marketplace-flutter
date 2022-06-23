import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/widgets/sale_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesContainer extends StatefulWidget {
  const SalesContainer({Key? key}) : super(key: key);

  @override
  State<SalesContainer> createState() => _SalesContainerState();
}

class _SalesContainerState extends State<SalesContainer> {
  // styling
  final lightTextStyle = const TextStyle(
    color: Color(0xFF777777),
  );

  // heading-text
  final headingTextStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

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

  // ! sales data
  var sales = [];
  bool foundSales = false;
  bool foundError = false;
  bool isLoadingSales = true;

  // ! load sales
  Future<void> getSales() async {
    // * if user refreshes, go back to loading screen
    setState(() {
      isLoadingSales = true;
    });

    // get url from EndPoint
    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/sales/';
    url += userEmail + '/';
    url += apiToken;

    try {
      final response = await Dio().get(url);
      final jsonData = response.data as List;

      // ! (checking mounted), to see that if the widget is still in the tree or not
      if (mounted) {
        setState(() {
          isLoadingSales = false;
          sales = jsonData;
          foundSales = true;
        });
      }
      // *

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
    getSales();
  }

  @override
  void initState() {
    super.initState();
    // * loading api token and orders data
    loadInOrder();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // * width
      width: MediaQuery.of(context).size.width,
      // * height
      // height: 250,
      // * child
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ! heading and refresg btn
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // * text
              Text(
                'Sales',
                style: headingTextStyle,
              ),

              // * refresh-btn
              IconButton(
                onPressed: getSales,
                icon: const Icon(PhosphorIcons.arrowCounterClockwiseBold),
              ),
            ],
          ),

          // ! data
          // ! sales
          // ! while loading sales
          if (isLoadingSales)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (sales.isEmpty)
            // ! after loading >> if empty
            noSalesPlaceholder(context)
          else
            SizedBox(
              height: 450,
              // * listview builder
              child: ListView.builder(
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  final sale = sales[index];
                  return SaleItem(
                    serviceId: sale['service_id'],
                    orderId: sale['order_id'],
                    buyerMail: sale['buyer_mail'],
                    buyerName: sale['buyer_name'],
                    serviceName: sale['service_name'],
                    count: int.parse(sale['count'].toString()),
                    dateTime: DateTime.parse(sale['date_created']),
                    servicePrice: double.parse(sale['price'].toString()),
                    imageTitle: sale['image_title'],
                    category: sale['category'],
                  );
                },
              ),
            ),

          const Divider(color: Colors.black),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total orders remaining: '),
                Text(sales.length.toString()),
              ],
            ),
          ),

          const Divider(color: Colors.black),
        ],
      ),
    );
  }

  Widget noSalesPlaceholder(BuildContext context) {
    return SizedBox(
      // * width
      width: MediaQuery.of(context).size.width,
      // * child
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ! space
          const SizedBox(height: 60),

          Image.asset(
            'assets/illustrations/empty_list.png',
            width: 100,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            'No sales yet.',
            style: lightTextStyle,
          ),
          Text(
            'Create services to get sales.',
            style: lightTextStyle,
          ),
        ],
      ),
    );
  }
}
