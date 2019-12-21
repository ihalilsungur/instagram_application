import 'package:flutter/material.dart';
import 'package:instagram_application/models/user.dart';
import 'package:instagram_application/utilities/constants.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      backgroundImage: NetworkImage(
                          "https://images.hdqwalls.com/wallpapers/bthumb/fox-depth-4k-oi.jpg"),
                    ),
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
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("posts")
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "386",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("follwers")
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "345",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("following")
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width:
                                MediaQuery.of(context).size.width * 1 / 2 - 10,
                            child: RaisedButton(
                              color: Colors.blue,
                              onPressed: () {
                                debugPrint("Edit Profile");
                              },
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
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
