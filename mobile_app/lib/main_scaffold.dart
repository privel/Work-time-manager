import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  void _onTabChange(int index) {
    print('tap index = $index');
    print('current index = ${navigationShell.currentIndex}');
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
        ),
        child: GNav(
          selectedIndex: navigationShell.currentIndex,
          onTabChange: _onTabChange,
          // rippleColor:
          //     Colors.grey.shade700, // tab button ripple color when pressed

          // hoverColor: Colors.grey.shade700, // tab button hover color
          haptic: true, // haptic feedback
          tabBorderRadius: 30,
          tabActiveBorder: Border.all(
            color: Colors.grey.shade800,
            width: 1.5,
          ), // tab button border
          // tabBorder: Border.all(
          //   color: Colors.grey,
          //   width: 1,
          // ), // tab button border
          // tabShadow: [
          //   BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8),
          // ], // tab button shadow
          //curve: Curves.bounceIn, // tab animation curves
          duration: Duration(milliseconds: 30), // tab animation duration
          gap: 5, // the tab button gap between icon and text
          color: Colors.grey[800], // unselected icon color
          activeColor: Colors.grey[800], // selected icon and text color
          iconSize: 24, // tab button icon size
          // selected tab background color
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 12,
          ), // navigation bar padding
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.search, text: 'Leaders'),
          ],
        ),
      ),
    );
  }
}
