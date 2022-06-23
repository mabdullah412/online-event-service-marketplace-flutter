import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/models/user_mode.dart';
import 'package:semester_project/screens/service_page.dart';
import 'package:semester_project/widgets/add_to_package.dart';

class ServiceTile extends StatelessWidget {
  ServiceTile({
    Key? key,
    required this.sName,
    required this.imageAddress,
    required this.sDescription,
    required this.sPrice,
    required this.sRating,
    required this.sSeller,
    required this.sSellerEmail,
    required this.sId,
    required this.sLocation,
  }) : super(key: key);

  // service seller
  final String sSeller;
  // service seller
  final String sId;
  // service seller
  final String sSellerEmail;
  // service name
  final String sName;
  // service description
  final String sDescription;
  // service rating
  final double sRating;
  // price
  final double sPrice;
  // location
  final String sLocation;
  // image address
  final String imageAddress;

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

  // * open modal sheet for adding to package
  void _addToPackage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddToPackage(sId: sId, sName: sName);
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

  @override
  Widget build(BuildContext context) {
    // ! endpoint to GET image
    var url = Provider.of<EndPoint>(context, listen: false).imageEndpoint;

    // ! getting seller mode status
    bool _sellerMode = Provider.of<UserMode>(context, listen: false).sellerMode;

    return Container(
      // width
      width: MediaQuery.of(context).size.width,
      // margin
      margin: const EdgeInsets.only(bottom: 20),
      // decoration
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: containerShadow,
        borderRadius: containerRadius,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 25,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * seller profile
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // * avatar and name
              Row(
                children: [
                  const CircleAvatar(
                    child: Icon(PhosphorIcons.user, color: Colors.white),
                    radius: 20,
                    backgroundColor: Color(0xFF333333),
                  ),
                  const SizedBox(width: 10),
                  Text(sSeller),
                ],
              ),
              // * menu
              IconButton(
                onPressed: () {},
                tooltip: 'Menu',
                icon: const Icon(PhosphorIcons.dotsThreeBold, size: 30),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // * service image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              url + imageAddress,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * service title
              Text(
                sName,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),

              // * service price
              RichText(
                text: TextSpan(
                  text: 'from ',
                  style: const TextStyle(
                    color: Color(0xFF777777),
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text: sPrice.toString() + ' Rs',
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // * Description
          Text(
            sDescription,
            style: const TextStyle(
              color: Color(0xFF777777),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),

          // * Rating
          // Row(
          //   children: [
          //     const Icon(
          //       PhosphorIcons.starFill,
          //       color: Colors.amber,
          //       size: 18,
          //     ),
          //     const SizedBox(width: 5),
          //     Text(
          //       sRating.toString(),
          //       style: const TextStyle(
          //         color: Colors.amber,
          //       ),
          //     ),
          //   ],
          // ),
          Text('Location: ' + sLocation),

          // * divider
          const Divider(color: Color(0xFF999999)),

          // * Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // * Learn more Button
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServicePage(
                            sSeller: sSeller,
                            sId: sId,
                            sSellerEmail: sSellerEmail,
                            sName: sName,
                            sDescription: sDescription,
                            sRating: sRating,
                            sPrice: sPrice,
                            imageAddress: imageAddress,
                            sLocation: sLocation,
                          ),
                        ),
                      );
                    },
                    child: const Text('Learn more'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  // * save Button
                  // IconButton(
                  //   onPressed: () {},
                  //   tooltip: 'Save',
                  //   icon: const Icon(PhosphorIcons.bookmarkSimple),
                  // ),

                  // * add to package Button
                  IconButton(
                    onPressed: () {
                      if (_sellerMode == false) {
                        _addToPackage(context);
                      } else {
                        null;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '⚠ Can\'t add to package while in seller mode.',
                            ),
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
                    },
                    tooltip: 'Add to package',
                    icon: const Icon(PhosphorIcons.listPlus),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
