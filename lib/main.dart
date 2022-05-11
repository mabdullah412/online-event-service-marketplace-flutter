import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';

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
    return MultiProvider(
      // * providers
      providers: [
        ChangeNotifierProvider(
          create: (context) => EndPoint(),
        ),
      ],

      // * app
      child: MaterialApp(
        // title
        title: 'Event Planner',

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
        home: const PageviewController(),
      ),
    );
  }
}
