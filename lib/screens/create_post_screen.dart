import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_application/models/post.dart';
import 'package:instagram_application/models/user.data.dart';
import 'package:instagram_application/services/database_service.dart';
import 'package:instagram_application/services/storage_service.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File _image;
  TextEditingController _captionController = TextEditingController();
  String _caption;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Posta Gönderme",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _submit(),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: height,
            child: Column(
              children: <Widget>[
                _isLoading
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.blue[200],
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      )
                    :SizedBox.shrink(),
                     GestureDetector(
                        onTap: _showSelectImageDialog,
                        child: Container(
                          width: width,
                          height: width,
                          color: Colors.grey[300],
                          child: _image == null
                              ? Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white70,
                                  size: 150,
                                )
                              : Image(
                                  image: FileImage(_image),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 15,right: 15),
                  child: TextField(
                    controller: _captionController,
                    decoration: InputDecoration(
                      labelText: "Başlık",
                      labelStyle: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),),
                    onChanged: (input) => _caption = input,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text("Fotoğraf Ekle"),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text("Fotoğref Çek"),
                onPressed: () => _handleImage(ImageSource.camera),
              ),
              CupertinoActionSheetAction(
                child: Text("Galeriden Fotoğraf Seç"),
                onPressed: () => _handleImage(ImageSource.gallery),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
                child: Text("Kapat"), onPressed: () => Navigator.pop(context)),
          );
        });
  }

  _submit() async {
    if (!_isLoading && _image != null && _caption.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      //gönderi paylaşma
      String imageUrl = await StorageService.uploadPost(_image);
      Post post = new Post(
        imageUrl: imageUrl,
        caption: _caption,
        likeCount: 0,
        authorId: Provider.of<UserData>(context).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      DatabaseService.createPost(post);

      //data resetleme
      _captionController.clear();

      setState(() {
        _caption = "";
        _image = null;
        _isLoading = false;
      });
    }
  }

  _androidDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              "Fotoğraf Ekle",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  "Fotoğraf Çek",
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => _handleImage(ImageSource.camera),
              ),
              SimpleDialogOption(
                child: Text(
                  "Galeriden Fotoğraf Seç",
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => _handleImage(ImageSource.gallery),
              ),
              SimpleDialogOption(
                child: Text(
                  "Kapat",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

   _handleImage(ImageSource source) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
     // imageFile = await _cropImage(imageFile);
      setState(() {
        _image = imageFile;
      });
    }
  }

/*Resim kırpma metodu
  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return croppedImage;
  }
*/
}
