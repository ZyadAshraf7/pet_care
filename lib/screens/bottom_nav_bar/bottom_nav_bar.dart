import 'package:flutter/material.dart';
import 'package:pet_care/constants/colors.dart';
import 'package:pet_care/screens/appointments_screen/appointments_screen.dart';
import 'package:pet_care/screens/home_screen/home_screen.dart';
import 'package:pet_care/screens/my_appointments/my_appointments.dart';
import 'package:pet_care/screens/profile_screen/profile_screen.dart';
import 'package:pet_care/shared_preference/user_preference.dart';

import '../bag_screen/bag_screen.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    MyAppointments(),
    BagScreen(),
    ProfileScreen(),
  ];
  @override
  void initState() {
    super.initState();
    UserPreferences.keepUserLoggedIn();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.deepGrey,
        showUnselectedLabels: true,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Bag',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
