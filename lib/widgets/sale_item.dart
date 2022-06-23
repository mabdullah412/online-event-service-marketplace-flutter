import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaleItem extends StatefulWidget {
  const SaleItem({
    Key? key,
    required this.serviceId,
    required this.buyerMail,
    required this.serviceName,
    required this.count,
    required this.dateTime,
    required this.servicePrice,
    required this.imageTitle,
    required this.category,
    required this.orderId,
    required this.buyerName,
  }) : super(key: key);

  // * service id
  final String serviceId;
  // * service id
  final String orderId;
  // * buyer mail
  final String buyerMail;
  // * buyer mail
  final String buyerName;
  // * service name
  final String serviceName;
  // * service count
  final int count;
  // * service dateTime
  final DateTime dateTime;
  // * service servicePrice
  final double servicePrice;
  // * service imageTitle
  final String imageTitle;
  // * service category
  final String category;

  @override
  State<SaleItem> createState() => _SaleItemState();
}

class _SaleItemState extends State<SaleItem> {
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

  bool isCompletingSale = false;

  Future<void> _completeSale() async {
    // ! show loading spinner
    setState(() {
      isCompletingSale = true;
    });

    var url = Provider.of<EndPoint>(context, listen: false).endpoint;
    url += 'api/completeSale';

    try {
      // ! converting to formData
      final formData = FormData.fromMap({
        'orderId': widget.orderId,
        'serviceId': widget.serviceId,
        'token': apiToken,
      });
      // *

      final response = await Dio().post(
        url,
        data: formData,
      );

      if (response.toString() == 'completed') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '👍 Completed sale of ' +
                  widget.serviceName +
                  ' for ' +
                  widget.buyerName,
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
        // ! err
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠ Could not complete sale'),
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
          content: Text('⚠ Could not complete sale'),
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

    // ! stop showing loading spinner
    setState(() {
      isCompletingSale = false;
    });
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

  @override
  void initState() {
    super.initState();
    loadApiToken();
  }

  @override
  Widget build(BuildContext context) {
    var url = Provider.of<EndPoint>(context, listen: false).imageEndpoint;

    return Container(
      // margin
      margin: const EdgeInsets.symmetric(vertical: 5),
      // padding
      padding: const EdgeInsets.all(15),
      // constraints
      width: MediaQuery.of(context).size.width,
      // decoration
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: containerShadow,
        borderRadius: containerRadius,
      ),
      child: Row(
        children: [
          // ! image
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  url + widget.imageTitle,
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return const SizedBox(
                      height: 80,
                      width: 80,
                      child: Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ! count
              CircleAvatar(
                backgroundColor: const Color.fromARGB(150, 0, 0, 0),
                child: Text(
                  widget.count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),

          const VerticalDivider(),

          // !
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // * buyer name
                Text(widget.buyerName),

                // * date
                Text(
                  widget.dateTime.day.toString() +
                      '/' +
                      widget.dateTime.month.toString() +
                      '/' +
                      widget.dateTime.year.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 10),

                // * total cost
                Text('Total price: ' + widget.servicePrice.toString()),
              ],
            ),
          ),

          const VerticalDivider(),

          // ! complete-sale-btn
          IconButton(
            onPressed: _completeSale,
            icon: const Icon(
              PhosphorIcons.checkCircle,
            ),
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}
