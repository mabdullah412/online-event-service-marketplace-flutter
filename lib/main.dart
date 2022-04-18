import 'package:flutter/material.dart';

// screens
import './screens/pageview_controller_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title
      title: 'Flutter Demo',

      // theme
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF333333),
          secondary: const Color.fromARGB(10, 0, 0, 0),
        ),

        // appbar theme
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Color(0xFF333333),
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          color: Color(0xFFFFFFFF),
          elevation: 1,
        ),
      ),

      // home
      home: PageviewController(),
    );
  }
}
