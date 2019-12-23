import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';



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
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  static void logOut() {
   _auth.signOut();
 
  }

  static void login(String email,String password) async{
    try{
     await _auth.signInWithEmailAndPassword(email: email,password: password);
    }catch(e){
      print(e);
    }

  }
}
