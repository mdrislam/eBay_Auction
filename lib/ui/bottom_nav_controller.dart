import 'package:ebay_auction/const/AppColorsConst.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bottom_nav_controller_pages/dasboard_screen.dart';
import 'bottom_nav_controller_pages/home_screen.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({Key? key}) : super(key: key);

  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  int _currentIndex = 0;
  final _pages = [
    HomeScreen(),
    DasboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "eBay Auction",
          style: TextStyle(color: Colors.black, fontSize: 30.sp),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.blueGrey,
        selectedLabelStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              backgroundColor: AppColorsConst.deepOrrange),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              title: Text("Dasboard"),
              backgroundColor: AppColorsConst.deepOrrange),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
