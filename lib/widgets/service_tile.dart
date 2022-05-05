import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ServiceTile extends StatelessWidget {
  ServiceTile({
    Key? key,
    required this.sName,
    required this.imageAddress,
    required this.sDescription,
    required this.sPrice,
    required this.sRating,
  }) : super(key: key);

  // service name
  final String sName;
  // service description
  final String sDescription;
  // service rating
  final double sRating;
  // price
  final double sPrice;
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

  @override
  Widget build(BuildContext context) {
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
          // * service image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageAddress,
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
              // fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),

          // * Rating
          Row(
            children: [
              const Icon(
                PhosphorIcons.starFill,
                color: Colors.amber,
                size: 18,
              ),
              const SizedBox(width: 5),
              Text(
                sRating.toString(),
                style: const TextStyle(
                  color: Colors.amber,
                ),
              ),
            ],
          ),
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
                    onPressed: () {},
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
                  IconButton(
                    onPressed: () {},
                    tooltip: 'Save',
                    icon: const Icon(PhosphorIcons.bookmarkSimple),
                  ),

                  // * add to package Button
                  IconButton(
                    onPressed: () {},
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
