import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../constants/colors.dart';
import '../../shared_preference/user_preference.dart';
import '../bag_screen/bag_screen.dart';
import '../home_screen/home_screen.dart';
import '../my_appointments/my_appointments.dart';
import '../profile_screen/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

   PersistentTabController _controller =PersistentTabController(initialIndex: 0);
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    MyAppointments(),
    BagScreen(),
    ProfileScreen(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: AppColors.primaryBlue,
        inactiveColorPrimary: AppColors.deepGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.star_border),
        title: 'Bookings',
        activeColorPrimary: AppColors.primaryBlue,
        inactiveColorPrimary: AppColors.deepGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_bag),
        title: 'Bag',
        activeColorPrimary: AppColors.primaryBlue,
        inactiveColorPrimary: AppColors.deepGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: 'Profile',
        activeColorPrimary: AppColors.primaryBlue,
        inactiveColorPrimary: AppColors.deepGrey,
      ),
    ];
  }
  @override
  void initState() {
    super.initState();
    UserPreferences.keepUserLoggedIn();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _screens,
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }
}
