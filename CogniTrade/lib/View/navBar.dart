import 'package:crypto/View/dashboard.dart';
import 'package:crypto/View/news.dart';
import 'package:flutter/material.dart';

import 'anotherPage.dart';
import 'home.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  List<Widget> pages = [
    DashboardScreen(),
    Portfolio(),
    TransactionsView(),
    NewsListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pages.elementAt(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            onTap: ((value) {
              setState(() {
                _currentIndex = value;
              });
            }),
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/1.1.png',
                    height: myHeight * 0.03,
                    color: Colors.grey,
                  ),
                  label: '',
                  activeIcon: Image.asset(
                    'assets/icons/1.2.png',
                    height: myHeight * 0.03,
                    color: Color(0xffFBC700),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/2.1.png',
                    height: myHeight * 0.03,
                    color: Colors.grey,
                  ),
                  label: '',
                  activeIcon: Image.asset(
                    'assets/icons/2.2.png',
                    height: myHeight * 0.03,
                    color: Color(0xffFBC700),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/transaction.png',
                    height: myHeight * 0.03,
                    color: Colors.grey,
                  ),
                  label: '',
                  activeIcon: Image.asset(
                    'assets/icons/transaction.png',
                    height: myHeight * 0.03,
                    color: Color(0xffFBC700),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/media.png',
                    height: myHeight * 0.03,
                    color: Colors.grey,
                  ),
                  label: '',
                  activeIcon: Image.asset(
                    'assets/icons/media.png',
                    height: myHeight * 0.03,
                    color: Color(0xffFBC700),
                  )),
            ]),
      ),
    );
  }
}
