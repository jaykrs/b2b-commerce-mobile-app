import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:EazySupplies/views/menu/Brand_page.dart';
import '../../core/constants/app_icons.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_defaults.dart';
import '../cart/cart_page.dart';
import '../home/home_page.dart';
import '../menu/menu_page.dart';
import '../profile/profile_page.dart';
import '../save/save_page.dart';
import 'components/app_navigation_bar.dart';

/// This page will contain all the bottom navigation tabs
class EntryPointUI extends StatefulWidget {
  const EntryPointUI({super.key});

  @override
  State<EntryPointUI> createState() => _EntryPointUIState();
}

class _EntryPointUIState extends State<EntryPointUI> {
  int currentIndex = 0;

  void onBottomNavigationTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> pages = [
    const HomePage(),
    const MenuPage(),
    const CartPage(isHomePage: true),
    const BrandPage(isHomePage: false),
    const ProfilePage(),
  ];

  DateTime? lastBackPressTime;

  Future<bool> _onWillPop() async {
    if (currentIndex != 0) {
      // If not on home tab, go to home tab
      setState(() {
        currentIndex = 0;
      });
      return false; // prevent app from exiting
    }

    // If already on home tab, check double press to exit
    final now = DateTime.now();
    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
      lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Press back again to exit")),
      );
      return false; // prevent exit
    }
    return true; // allow exit
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageTransitionSwitcher(
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
            return SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: AppColors.scaffoldBackground,
              child: child,
            );
          },
          duration: AppDefaults.duration,
          child: pages[currentIndex],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            onBottomNavigationTap(2); // go to cart tab
          },
          backgroundColor: AppColors.primary,
          child: SvgPicture.asset(AppIcons.cart),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AppBottomNavigationBar(
          currentIndex: currentIndex,
          onNavTap: onBottomNavigationTap,
        ),
      ),
    );
  }
}

