import 'package:dream_partner/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../navigation/custom_animated_bottom_bar.dart';
import '../home/home_page.dart';
import '../likes/likes_page.dart';
import '../messages/messages_page.dart';
import '../profile/profile_display.dart';

class MyDashBoard extends StatefulWidget {
  @override
  _MyDashBoardState createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  int _currentIndex = 0;

  final _inactiveColor = AppTheme.colors.inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: Center(
              child: Padding(
                padding:EdgeInsets.only(top: 10),
                child: Text("Dream Partner",
                    style: GoogleFonts.getFont('Clicker Script',
                        fontSize: Get.width * 0.115,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.darkPeach),),
              )),
          backgroundColor: AppTheme.colors.white,
        ),
        body: getBody(),
        bottomNavigationBar: _buildBottomBar());
  }

  Widget _buildBottomBar() {
    return CustomAnimatedBottomBar(
      containerHeight: 60,
      backgroundColor: AppTheme.colors.white,
      selectedIndex: _currentIndex,
      showElevation: false,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(Icons.home),
          title: const Text('Home'),
          activeColor: AppTheme.colors.darkPeach,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.favorite_outlined),
          title: const Text('Likes'),
          activeColor: AppTheme.colors.darkPeach,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.message),
          title: const Text(
            'Messages ',
          ),
          activeColor: AppTheme.colors.darkPeach,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.person_2),
          title: const Text('Profile'),
          activeColor: AppTheme.colors.darkPeach,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget getBody() {
    List<Widget> pages = [
      HomePage(),
      LikesPage(),
      ChatScreen(),
      ProfileDisplay(),
    ];
    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }
}
