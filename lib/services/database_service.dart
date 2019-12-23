import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_application/models/user.dart';
import 'package:instagram_application/utilities/constants.dart';

class DatabaseService {
  static void updateUser(User user) {
    userRef.document(user.id).updateData({
      "name": user.name,
      "bio": user.bio,
      "profileImageUrl": user.profileImageUrl
    });
  }

  static Future<QuerySnapshot> searchUser(String name) {
    Future<QuerySnapshot> _users =
        userRef.where("name", isGreaterThanOrEqualTo: name).getDocuments();
    return _users;
  }
}
