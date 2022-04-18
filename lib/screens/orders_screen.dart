import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  // styling
  // light-text
  final lightTextStyle = const TextStyle(
    color: Color(0xFF777777),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      // width
      width: MediaQuery.of(context).size.width,
      // bg-color
      color: const Color(0xFFF8F8F8),
      // padding
      padding: const EdgeInsets.only(
        top: 40,
        right: 20,
        left: 20,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/illustrations/empty_orders_list.png',
              width: 150,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'No orders yet',
              style: lightTextStyle,
            ),
            Text(
              'Find the right service for you.',
              style: lightTextStyle,
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Explore the marketplace',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
