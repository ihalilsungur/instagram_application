import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_application/models/user.dart';
import 'package:instagram_application/services/database_service.dart';
import 'package:instagram_application/services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({this.user});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File _profileImage;
  String _name = "";
  String _bio = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  _handleImageFromGallery() async {
    File _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_imageFile != null) {
      setState(() {
        _profileImage = _imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Profil Güncelleme",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          backgroundImage: _displayProfileImage()),
                      FlatButton(
                        onPressed: _handleImageFromGallery,
                        child: Text(
                          "Profil Resmini Değiştir",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            size: 35,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          labelText: "Adınız",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        validator: (input) => input.trim().length < 1
                            ? "Lütfen Geçerli Bir Ad Giriniz"
                            : null,
                        onSaved: (value) {
                          _name = value;
                        },
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: _bio,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.book,
                              size: 35,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            labelText: "Biyografi",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18)),
                        validator: (input) => input.trim().length > 150
                            ? "Lütfen En Fazla 150 Karakter Bir Biyografi Giriniz"
                            : null,
                        onSaved: (value) {
                          _bio = value;
                        },
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            fontSize: 18),
                      ),
                      Container(
                        margin: EdgeInsets.all(30),
                        height: MediaQuery.of(context).size.height * 1 / 14,
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: () => _submit(),
                          color: Colors.blue,
                          child: Text(
                            "Profili Kaydet",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      String _profileImageUrl = "";

      if (_profileImage == null) {
        _profileImageUrl = widget.user.profileImageUrl;
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
            widget.user.profileImageUrl, _profileImage);
      }
      // kullanıcı güncelleme
      User _user = User(
          id: widget.user.id,
          name: _name,
          bio: _bio,
          profileImageUrl: _profileImageUrl);
      //vertiatabanı güncelleme
      DatabaseService.updateUser(_user);
      Navigator.pop(context);
    }
  }

  _displayProfileImage() {
    //eğer profil resmi yok ise
    if (_profileImage == null) {
      //kullanıcının profil resmi yok ise
      if (widget.user.profileImageUrl.isEmpty) {
        //display holder
        return AssetImage("assets/images/user_placeholder.jpg");
      } else {
        // kullanıcının profil resmi var sa
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    } else {
      //eğer profile resmi var ise
      return FileImage(_profileImage);
    }
  }
}
