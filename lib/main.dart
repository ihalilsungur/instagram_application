
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_application/models/user.data.dart';
import 'package:instagram_application/screens/feed_screen.dart';
import 'package:instagram_application/screens/home_screen.dart';
import 'package:instagram_application/screens/login_screen.dart';
import 'package:instagram_application/screens/signup_screen.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return HomeScreen(
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Application',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryIconTheme:
              Theme.of(context).primaryIconTheme.copyWith(color: Colors.black),
        ),
        home: _getScreenId(),
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          FeedScreen.id: (context) => FeedScreen()
        },
      ),
    );
  }
}
