import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String profilrImageUrl;
  final String email;
  final String bio;

  User({
    this.id,
    this.name,
    this.profilrImageUrl,
    this.email,
    this.bio,
  });

  factory User.fromDoc(DocumentSnapshot doc){
    return User(
      id: doc.documentID,
      name : doc["name"],
      profilrImageUrl: doc["profileImageUrl"],
      email: doc["email"],
      bio: doc["bio"] ?? ""
    );
  }
}