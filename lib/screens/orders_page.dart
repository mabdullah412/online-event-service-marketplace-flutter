import 'package:flutter/material.dart';
import 'package:semester_project/widgets/orders_container.dart';
import 'package:semester_project/widgets/packages_container.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  // styling
  // heading-text
  final headingTextStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
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
        top: 30,
        right: 20,
        left: 20,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orders',
              style: headingTextStyle,
            ),
            const SizedBox(height: 60),
            const OrdersContainer(),
            const SizedBox(height: 60),
            Text(
              'Packages',
              style: headingTextStyle,
            ),
            const SizedBox(height: 60),
            const PackagesContainer(),
          ],
        ),
      ),
    );
  }
}