import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_application/models/post.dart';
import 'package:instagram_application/models/user.dart';
import 'package:instagram_application/screens/profile_screen.dart';

class PostView extends StatelessWidget {
  final String currentUserId;
  final  Post post;
  final User author;

  PostView({this.currentUserId,this.post,this.author});
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ProfileScreen(
                currentUserId: currentUserId,
                userId: post.authorId,
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  backgroundImage: author.profileImageUrl.isEmpty
                      ? AssetImage("assets/images/user_placeholder.jpg")
                      : CachedNetworkImageProvider(author.profileImageUrl),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  author.name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                )
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(post.imageUrl),
                  fit: BoxFit.cover)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      size: 40,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.comment,
                      size: 40,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  "1 beğenme",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 6),
                    child: Text(
                      author.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      post.caption,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      ],
    );
  }
}