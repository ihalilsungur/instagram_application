import 'package:flutter/material.dart';
import 'package:instagram_application/services/auth_service.dart';

class FeedScreen extends StatefulWidget {
  static final String id= "feed_screen";
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.blue,
      body: Center(
        child: FlatButton(
             onPressed: ()=>AuthService.logOut(context) ,
             child: Text("Çıkış",
             style: TextStyle(
               color: Colors.white,
               fontSize: 23,
               fontWeight: FontWeight.bold
             ),),
        ),
      ),
    );
  }
}