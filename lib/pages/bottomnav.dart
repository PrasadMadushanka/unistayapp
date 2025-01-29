import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:unistaynew/pages/orderPage.dart';
import 'package:unistaynew/pages/home.dart';

import 'package:unistaynew/pages/profile.dart';



class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  late List<Widget> pages;

  late Home HomePage;
  late OrderPage orderPage;
  late Profile profile;
  int currentTabIndex = 0;

  @override
  void initState() {
    HomePage = const Home();
    orderPage = const OrderPage();
    profile = const Profile();
    pages = [HomePage, orderPage, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 50,
          backgroundColor: const Color(0xfff2f2f2),
          animationDuration: const Duration(milliseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: const [
            Icon(
              Icons.home_outlined,
              color: Colors.black,
            ),
            Icon(
              Icons.bookmark_add_outlined,
              color: Colors.black,
            ),
            Icon(
              Icons.person_outlined,
              color: Colors.black,
            ),
          ]),
      body: pages[currentTabIndex],
    );
  }
}
