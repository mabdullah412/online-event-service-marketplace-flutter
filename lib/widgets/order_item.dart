import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/widgets/order_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    Key? key,
    required this.id,
    required this.dateTime,
    required this.price,
  }) : super(key: key);

  // * order id
  final String id;
  // * order date
  final DateTime dateTime;
  // * order price
  final double price;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  // container-decorations
  final containerRadius = BorderRadius.circular(10);

  // 2. box-shadow
  final containerShadow = const [
    BoxShadow(
      color: Color.fromARGB(15, 0, 0, 0),
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];

  // ! for viewing items in the order
  void _seeItems(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return OrderServices(
          id: widget.id,
          dateTime: widget.dateTime,
          price: widget.price,
        );
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

  bool cancellingOrder = false;

  Future<void> _cancelOrder() async {
    // ! show loading spinner, in place of delete btn
    setState(() {
      cancellingOrder = true;
    });

    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/cancelOrder';

    try {
      // ! converting to formData
      final formData = FormData.fromMap({
        'orderId': widget.id,
        'token': apiToken,
      });

      final response = await Dio().post(
        url,
        data: formData,
      );

      if (response.toString() == 'cancelled') {
        // ! removed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('👍 Order cancelled successfully'),
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
            content: Text('⚠ Error cancelling order'),
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
          content: Text('⚠ Could not cancel order'),
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

    setState(() {
      cancellingOrder = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // * laoding api token
    loadApiToken();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width
      width: MediaQuery.of(context).size.width,
      // margin
      margin: const EdgeInsets.symmetric(vertical: 5),
      // decoration
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: containerShadow,
        borderRadius: containerRadius,
      ),

      // child
      child: ListTile(
        // * icon
        leading: const CircleAvatar(
          child: Icon(
            PhosphorIcons.bag,
            color: Colors.grey,
          ),
          backgroundColor: Colors.white,
        ),
        // * o-id
        title: Text(
          'Order # ' +
              widget.dateTime.day.toString() +
              '/' +
              widget.dateTime.month.toString() +
              '/' +
              widget.dateTime.year.toString(),
        ),
        // * sub-tite
        subtitle: Text('Rs. ' + widget.price.toString()),
        // * delete-btn
        trailing: cancellingOrder == false
            ? IconButton(
                onPressed: _cancelOrder,
                icon: const Icon(
                  PhosphorIcons.trashSimple,
                  color: Colors.red,
                ),
              )
            : const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
        // * onTap
        onTap: () {
          _seeItems(context);
        },
      ),
    );
  }
}
