import 'dart:async';

import 'package:ebay_auction/const/AppColorsConst.dart';
import 'package:ebay_auction/ui/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bottom_nav_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), () {
      if (_auth.currentUser!.uid.isNotEmpty) {
        Navigator.push(
            context, CupertinoPageRoute(builder: (_) => BottomNavController()));
      } else {
        Navigator.push(
            context, CupertinoPageRoute(builder: (_) => SignUpScreen()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsConst.deepOrrange,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "eBay Auction",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 44.sp),
              ),
              SizedBox(
                height: 20.h,
              ),
              CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
