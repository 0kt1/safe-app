// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:safeapp/screens/app_blocker_screen.dart';
// import 'package:safeapp/screens/dashboard.dart';
// import 'package:safeapp/screens/profile.dart';
// import 'package:safeapp/screens/safe_app_screen.dart';
// import 'package:safeapp/screens/test.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   final List<Widget> _screens = [
//     // SecureContainerScreen(),
//     const ManageAppsScreen(),
//     const DashboardPage(),
//     const ProfileScreen(),
//     // const AppBlockerScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Safe App'),
//       // ),
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         type: BottomNavigationBarType.fixed,
//         selectedIconTheme: const IconThemeData(color: Colors.white),
//         unselectedIconTheme: const IconThemeData(color: Colors.grey, size: 25),
//         selectedLabelStyle: GoogleFonts.inter(
//                                   fontSize: 12,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//         iconSize: 30,
//         elevation: 5,
//         unselectedLabelStyle: const TextStyle(color: Colors.grey),
//         items: const <BottomNavigationBarItem>[
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.lock),
//           //   label: 'Secure Container',
//           // ),

//           BottomNavigationBarItem(
//             icon: Icon(Icons.lock),
//             label: 'Manage Apps',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.telegram),
//           //   label: 'Block Apps',
//           // ),
//         ],
//         currentIndex: _selectedIndex,
//         // selectedItemColor: Colors.deepPurple,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeapp/components/side_drawer.dart';
import 'package:safeapp/screens/app_blocker_screen.dart';
import 'package:safeapp/screens/dashboard.dart';
import 'package:safeapp/screens/financialapps.dart';
import 'package:safeapp/screens/detect_apps.dart';
import 'package:safeapp/screens/profile.dart';
import 'package:safeapp/screens/toggle_apps.dart';
import 'package:safeapp/screens/test.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const FinancialAppsScreen(),
    DetectAppsScreen(),
    const DashboardPage(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(child: _screens[_selectedIndex]),
      drawer: const SideDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 21, 29, 42),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        iconSize: 26,
        elevation: 8,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Financial Apps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Detect Apps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
