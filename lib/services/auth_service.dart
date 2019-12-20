import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_application/screens/feed_screen.dart';
import 'package:instagram_application/screens/login_screen.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static void signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser signInUser = authResult.user;
      if (signInUser != null) {
        _firestore.collection("/users").document(signInUser.uid).setData({
          "name": name,
          "email": email,
          "password": password,
          "profileImageUrl": ""
        });
        Navigator.pushReplacementNamed(context, FeedScreen.id);
      }
    } catch (e) {
      print(e);
    }
  }

  static void logOut(BuildContext context) {
   _auth.signOut();
   Navigator.pushReplacementNamed(context, LoginScreen.id);
  }

  static void login(String email,String password) async{
  _auth.signInWithEmailAndPassword(email: email,password: password);
  }
}
