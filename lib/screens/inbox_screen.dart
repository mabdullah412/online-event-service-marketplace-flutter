import 'package:flutter/material.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
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
              'assets/illustrations/no_messages.png',
              width: 150,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'No messages yet',
              style: lightTextStyle,
            ),
            Text(
              'Start a conversation with the service providers, and get the job done.',
              style: lightTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
