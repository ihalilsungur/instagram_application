import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Instagram",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Billabong",
                fontSize: 35,
                fontWeight: FontWeight.w300),
          ),
        ),
      ),
      body: Center(child: Text("Activity Screen")),
    );
  }
}
