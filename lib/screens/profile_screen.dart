import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_application/models/user.dart';
import 'package:instagram_application/models/user.data.dart';
import 'package:instagram_application/screens/edit_profile_screen.dart';
import 'package:instagram_application/services/database_service.dart';
import 'package:instagram_application/utilities/constants.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String userId;
  ProfileScreen({this.currentUserId, this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
  }

  _setupIsFollowing() async {
    bool _isFollowingUser = await DatabaseService.isFollowing(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      isFollowing = _isFollowingUser;
    });
  }

  _setupFollowers() async {
    int _userFollowerCount = await DatabaseService.numFollowers(widget.userId);
    setState(() {
      followerCount = _userFollowerCount;
    });
  }

  _setupFollowing() async {
    int _userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    setState(() {
      followingCount = _userFollowingCount;
    });
  }

 _followOrUnfollow(){
   if (isFollowing) {
     _unfollowUser();
   }else{
     _followUser();
   }
 }

 _followUser(){
   DatabaseService.followUser(
     currentUserId: widget.currentUserId,
     userId: widget.userId
   );
   setState(() {
     isFollowing = true;
     followerCount++;
   });

   print("_followUser() metodu _isFollow :"+isFollowing.toString());
 }

 _unfollowUser(){
   DatabaseService.unFollowUser(
     currentUserId: widget.currentUserId,
     userId: widget.userId
   );
   setState(() {
     isFollowing = false;
     followerCount--;
   });
   print("_unfollowUser() metodu _isFollow :"+isFollowing.toString());
 }
  _displayButton(User _user) {
    return _user.id == Provider.of<UserData>(context).currentUserId
        ? Container(
            width: MediaQuery.of(context).size.width * 1 / 2 - 10,
            child: RaisedButton(
              color: Colors.blue,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => EditProfileScreen(
                    user: _user,
                  ),
                ),
              ),
              child: Text(
                "Profili Güncelle",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width * 1 / 2 - 10,
            child: RaisedButton(
              color: isFollowing ? Colors.grey[200] : Colors.blue,
              textColor: isFollowing ? Colors.black : Colors.white,
              onPressed: () =>_followOrUnfollow(),
              child: Text(
                isFollowing ? "Vazgeç" : "Takip Et",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Instagram",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Billabong",
                fontSize: 35,
                fontWeight: FontWeight.w300),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: userRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User _user = User.fromDoc(snapshot.data);

          return ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        backgroundImage: _user.profileImageUrl.isEmpty
                            ? AssetImage("assets/images/user_placeholder.jpg")
                            : CachedNetworkImageProvider(
                                _user.profileImageUrl)),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "12",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  Text("Gönderi")
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    followerCount.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  Text("Takipçi",style: TextStyle(
                                    color: Colors.black87,
                                   
                                  ),)
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    followingCount.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  Text("Takip")
                                ],
                              ),
                            ],
                          ),
                          _displayButton(_user),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _user.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 100,
                      child: Text(
                        _user.bio,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Divider(
                      height: 1,
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
