import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/models/user_mode.dart';
import 'package:semester_project/widgets/add_to_package.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({
    Key? key,
    required this.sSeller,
    required this.sName,
    required this.sDescription,
    required this.sRating,
    required this.sPrice,
    required this.imageAddress,
    required this.sSellerEmail,
    required this.sId,
    required this.sLocation,
  }) : super(key: key);

  // service seller
  final String sSeller;
  // service seller
  final String sId;
  // service seller email
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
    var url = Provider.of<EndPoint>(context, listen: false).imageEndpoint;

    // ! getting seller mode status
    bool _sellerMode = Provider.of<UserMode>(context, listen: false).sellerMode;

    return Scaffold(
      body: Container(
        // width
        width: MediaQuery.of(context).size.width,
        // bg-color
        color: const Color(0xFFF8F8F8),
        // padding
        padding: const EdgeInsets.only(
          top: 60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * contains everything except the price container
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                children: [
                  // * banner image
                  Stack(
                    fit: StackFit.loose,
                    children: [
                      // * image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          url + imageAddress,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // * buttons on image
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // * back-btn
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(225, 255, 255, 255),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.grey,
                                icon: const Icon(PhosphorIcons.caretLeftBold),
                              ),
                            ),
                            // * bookmark-btn
                            // Container(
                            //   decoration: BoxDecoration(
                            //     color: const Color.fromARGB(225, 255, 255, 255),
                            //     borderRadius: BorderRadius.circular(50),
                            //   ),
                            //   child: IconButton(
                            //     onPressed: () {},
                            //     color: Colors.grey,
                            //     icon: const Icon(
                            //       PhosphorIcons.bookmarkSimpleBold,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // * extra images
                  // const SizedBox(height: 10),

                  // SizedBox(
                  //   height: 100,
                  //   child: ListView.builder(
                  //     itemCount: 8,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (context, index) {
                  //       return Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 5),
                  //         child: ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Image.asset(imageAddress),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),

                  const SizedBox(height: 10),

                  // * service seller
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            PhosphorIcons.userBold,
                            color: Colors.white,
                          ),
                          backgroundColor: Color(0xFF333333),
                        ),
                        title: Text(sSeller),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            PhosphorIcons.caretDownBold,
                          ),
                        ),
                      ),
                      // height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // * service title
                  Text(
                    sName,
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // * service description
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    sDescription,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 15),

                  // * service tags
                  // const Text(
                  //   'Tags',
                  //   style: TextStyle(fontWeight: FontWeight.w500),
                  // ),
                  // const SizedBox(height: 10),

                  const SizedBox(height: 15),

                  // * service location
                  const Text(
                    'Location',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    sLocation,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  // Container(
                  //   height: 250,
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey,
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  // ),

                  // * white spacing
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // * price and button container
            Container(
              // width
              width: MediaQuery.of(context).size.width,
              // padding
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              // child
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rs. ' + sPrice.toString(),
                    style: const TextStyle(),
                  ),
                  ElevatedButton(
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
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    child: const Text('Add to package'),
                  ),
                ],
              ),
              // decoration
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEEE),
                border: Border(
                  top: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
