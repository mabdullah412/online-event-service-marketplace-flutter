import 'package:flutter/material.dart';

// installed packages
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:semester_project/screens/settings_screen.dart';

// screens
import 'profile_screen.dart';
import 'orders_screen.dart';
import 'discover_screen.dart';
import 'inbox_screen.dart';
import 'home_screen.dart';

class PageviewController extends StatefulWidget {
  const PageviewController({Key? key}) : super(key: key);

  @override
  State<PageviewController> createState() => _PageviewControllerState();
}

class _PageviewControllerState extends State<PageviewController> {
  // gotoScreen functions
  // void _goToDiscoverScreen() {
  //   setState(() {
  //     index = 2;
  //   });
  // }

  // screens
  final screens = [
    const HomePage(),
    const InboxPage(),
    const DiscoverPage(),
    const OrdersPage(),
    const ProfilePage(),
  ];

  // appbar titles
  final screenTitles = const [
    'Home',
    'Inbox',
    'Discover',
    'Manage orders',
    'Profile',
  ];

  // showing home page at start
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitles[index]),
        actions: [
          if (index == 4)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
              icon: const Icon(
                PhosphorIcons.gearBold,
                color: Color(0xFF333333),
              ),
            ),
        ],
      ),
      // show screen on current index
      body: screens[index],
      // bottomNav
      bottomNavigationBar: NavigationBarTheme(
        // themedata
        data: const NavigationBarThemeData(
          // set selected icon bg-color to white with opacity 10
          indicatorColor: Colors.white10,
        ),
        child: Container(
          // shadow behind the bottom navbar
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(20, 0, 0, 0),
                blurRadius: 5,
              ),
            ],
          ),
          // NavigationBar
          child: NavigationBar(
            //height
            height: 65,
            // bg-color
            backgroundColor: Colors.white,
            // current selected item-index
            selectedIndex: index,
            // set new index
            onDestinationSelected: (index) {
              setState(() {
                this.index = index;
              });
            },
            // hide labels
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            // icons-array
            destinations: const [
              NavigationDestination(
                icon: Icon(PhosphorIcons.houseBold, size: 26),
                selectedIcon: Icon(PhosphorIcons.houseFill, size: 26),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(PhosphorIcons.paperPlaneTiltBold, size: 26),
                selectedIcon: Icon(PhosphorIcons.paperPlaneTiltFill, size: 26),
                label: 'Inbox',
              ),
              NavigationDestination(
                icon: Icon(PhosphorIcons.magnifyingGlassBold, size: 26),
                selectedIcon: Icon(PhosphorIcons.magnifyingGlassFill, size: 26),
                label: 'Discover',
              ),
              NavigationDestination(
                icon: Icon(PhosphorIcons.scrollBold, size: 26),
                selectedIcon: Icon(PhosphorIcons.scrollFill, size: 26),
                label: 'Orders',
              ),
              NavigationDestination(
                icon: Icon(PhosphorIcons.userCircleBold, size: 26),
                selectedIcon: Icon(PhosphorIcons.userCircleFill, size: 26),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
