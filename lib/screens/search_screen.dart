import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_application/models/user.dart';
import 'package:instagram_application/models/user.data.dart';
import 'package:instagram_application/screens/profile_screen.dart';
import 'package:instagram_application/services/database_service.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  Future<QuerySnapshot> _users;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(left: 5, bottom: 5),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1 / 16,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search, size: 30),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _searchClear(),
                ),
                filled: true,
                labelText: "Ara",
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              onSubmitted: (input) {
                print(input);
                if (input.isNotEmpty) {
                  setState(() {
                    _users = DatabaseService.searchUser(input);
                  });
                }
              },
            ),
          ),
        ),
        body: _users == null
            ? Center(
                child: Text(
                  "Kullanıcı Aramak İçin ",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              )
            : FutureBuilder(
                future: _users,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data.documents.length == 0) {
                    return Center(
                      child: Text(
                          "Hiç Bir Kullanıcı Bulunamadı! Lütfen Tekrar Deneyiniz"),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      User user = User.fromDoc(snapshot.data.documents[index]);
                      return _buildUserTile(user);
                    },
                  );
                },
              ));
  }

  _buildUserTile(User user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.profileImageUrl.isEmpty
            ? AssetImage("assets/images/user_placeholder.jpg")
            : CachedNetworkImageProvider(user.profileImageUrl),
      ),
      title: Text(
        user.name,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 22, color: Colors.blueGrey),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            currentUserId: Provider.of<UserData>(context).currentUserId,
            userId: user.id,
          ),
        ),
      ),
    );
  }

  _searchClear() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }
}
