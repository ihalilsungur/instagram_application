import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_application/models/post.dart';
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

  static void createPost(Post post) {
    postRef.document(post.authorId).collection("usersPosts").add({
      "imageUrl": post.imageUrl,
      "caption": post.caption,
      "likes": post.likes,
      "authorId": post.authorId,
      "timestamp": post.timestamp
    });
  }

  static void followUser({String currentUserId, String userId}) {
    //Mevcut kullanıcının aşağıdaki koleksiyonuna kullanıcı ekle
    followingRef
        .document(currentUserId)
        .collection("userFollowing")
        .document(userId)
        .setData({});

    //Mevcut kullanıcıyı kullanıcının takipçileri koleksiyonuna ekle
    followersRef
        .document(userId)
        .collection("userFollowers")
        .document(currentUserId)
        .setData({});
  }

  static void unFollowUser({String currentUserId, String userId}) {
    //Geçerli kullanıcının aşağıdaki koleksiyonundan kullanıcıyı kaldır
    followingRef
        .document(currentUserId)
        .collection("userFollowing")
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    //Mevcut kullanıcıyı kullanıcının takipçiler koleksiyonundan kaldır
    followersRef
        .document(userId)
        .collection("userFollowers")
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowing({String currentUserId, String userId}) async {
    DocumentSnapshot followingDoc = await followersRef
        .document(userId)
        .collection("userFollowers")
        .document(userId)
        .get();
    return followingDoc.exists;
  }

//takip etme sayısı
  static Future<int> numFollowing(String userId) async {
    QuerySnapshot _followingSnapshot = await followingRef
        .document(userId)
        .collection("userFollowing")
        .getDocuments();
    return _followingSnapshot.documents.length;
  }

//takipçi sayısı
  static Future<int> numFollowers(String userId) async {
    QuerySnapshot _followersSnapshot = await followersRef
        .document(userId)
        .collection("userFollowers")
        .getDocuments();
    return _followersSnapshot.documents.length;
  }
}
