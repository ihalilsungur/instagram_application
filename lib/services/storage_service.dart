import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:instagram_application/utilities/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadUserProfileImage(
      String url, File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);
    if (url.isNotEmpty) {
      //kullanıcı profil resmini güncelleme
      RegExp exp = RegExp(r'userProfile_(.*).jpg');
      photoId =exp.firstMatch(url)[1];
      print(photoId);
    }
    StorageUploadTask uploadTask = storageRef
        .child("images/users/userProfile_$photoId.jpg")
        .putFile(image);
    StorageTaskSnapshot storageShapshot = await uploadTask.onComplete;
    String downloadUrl = await storageShapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<File> compressImage(String photoId, File image) async {
    final temDir = await getTemporaryDirectory();
    final path = temDir.path;
    File compressImageFile = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path, "$path/img_$photoId.jpg",
        quality: 70);
    return compressImageFile;
  }
}
