import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/widgets/order_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersContainer extends StatefulWidget {
  const OrdersContainer({Key? key}) : super(key: key);

  @override
  State<OrdersContainer> createState() => _OrdersContainerState();
}

class _OrdersContainerState extends State<OrdersContainer> {
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

  // ! orders data
  var orders = [];
  bool foundOrders = false;
  bool foundError = false;
  bool isLoadingOrders = true;

  // ! load orders
  Future<void> getOrders() async {
    // * if user refreshes, go back to loading screen
    setState(() {
      isLoadingOrders = true;
    });

    // get url from EndPoint
    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/order/';
    url += userEmail + '/';
    url += apiToken;

    try {
      final response = await Dio().get(url);
      final jsonData = response.data as List;

      // ! (checking mounted), to see that if the widget is still in the tree or not
      if (mounted) {
        setState(() {
          isLoadingOrders = false;
          orders = jsonData;
          foundOrders = true;
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
    getOrders();
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
      height: 250,
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
                'Orders',
                style: headingTextStyle,
              ),

              // * refresh-btn
              IconButton(
                onPressed: getOrders,
                icon: const Icon(PhosphorIcons.arrowCounterClockwiseBold),
              ),
            ],
          ),

          // ! data
          // ! orders
          // ! while loading orders
          if (isLoadingOrders)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          // ! after loading >> if empty
          else if (orders.isEmpty)
            noOrdersPlaceholder(context)
          // ! after loading >> if not empty
          else
            SizedBox(
              height: 200,
              // * listview builder
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderItem(
                    id: order['id'],
                    dateTime: DateTime.parse(order['date_created']),
                    price: double.parse(order['total_price'].toString()),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget noOrdersPlaceholder(BuildContext context) {
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
            'assets/illustrations/empty_cart.png',
            width: 100,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            'No orders yet',
            style: lightTextStyle,
          ),
        ],
      ),
    );
  }
}
