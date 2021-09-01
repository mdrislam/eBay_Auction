import 'package:flutter/material.dart';

class DasboardScreen extends StatefulWidget {
  const DasboardScreen({Key? key}) : super(key: key);

  @override
  _DasboardScreenState createState() => _DasboardScreenState();
}

class _DasboardScreenState extends State<DasboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Dasboard"),
      ),
    );
  }
}
