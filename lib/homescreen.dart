import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/constants.dart';
import 'home.dart';
import 'reels.dart';
import 'search.dart';
import 'shop.dart';
import 'guest_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 0;
  List<Widget> pages = const <Widget>[
    Home(),
    Search(),
    Reels(),
    Shop(),
    UserSpace(),
  ];
  List<IconData> pagesIcons = const <IconData>[
    FontAwesomeIcons.house,
    FontAwesomeIcons.filter,
    FontAwesomeIcons.video,
    FontAwesomeIcons.shop,
    FontAwesomeIcons.userAstronaut,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[activeIndex],
      backgroundColor: bgColor,
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: CurvedNavigationBar(
        color: bgColor,
        items: pagesIcons
            .map((IconData id) => Icon(
                  id,
                  color: bgColor == Colors.white ? Colors.black : Colors.white,
                  size: 20,
                ))
            .toList(),
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: bgColor,
        //color: bgColor,
        height: 40,
        index: activeIndex,
        onTap: (int value) {
          setState(() {
            activeIndex = value;
          });
        },
      ),
    );
  }
}
