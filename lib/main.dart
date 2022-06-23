import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semester_project/models/endpoint.dart';
import 'package:semester_project/models/user_mode.dart';
import 'package:semester_project/screens/authentication_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// screens
import 'screens/pageview_controller_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ! used to check, if signUp/logIn screen needs to be shown or not
  final localUserData = await SharedPreferences.getInstance();
  // await localUserData.setBool('ep_loggedin', false);
  final isLoggedIn = localUserData.getBool('ep_loggedin') ?? false;

  runApp(
    MyApp(isLoggedIn: isLoggedIn),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // * providers
      providers: [
        ChangeNotifierProvider(
          create: (context) => EndPoint(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserMode(),
        ),
      ],

      // * app
      child: MaterialApp(
        // * title
        title: 'Event Planner',

        // * theme
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

        // * home
        home: isLoggedIn
            ? const PageviewController()
            : const AuthenticationScreen(),
      ),
    );
  }
}
