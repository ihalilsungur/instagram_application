import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_application/models/post.dart';
import 'package:instagram_application/models/user.dart';
import 'package:instagram_application/screens/comments_screen.dart';
import 'package:instagram_application/screens/profile_screen.dart';
import 'package:instagram_application/services/database_service.dart';

class PostView extends StatefulWidget {
  final String currentUserId;
  final Post post;
  final User author;

  PostView({this.currentUserId, this.post, this.author});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  int _likeCount = 0;
  bool _isLiked = false;
  bool _heartAnim = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likeCount;
    _initPostLiked();
  }

  @override
  void didUpdateWidget(PostView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.likeCount != widget.post.likeCount) {
      _likeCount = widget.post.likeCount;
    }
  }

  _initPostLiked() async {
    bool isLiked = await DatabaseService.didLikePost(
      currentUserId: widget.currentUserId,
      post: widget.post,
    );
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  _likePost() {
    if (_isLiked) {
      //unlike Post
      DatabaseService.unlikePost(
          currentUserId: widget.currentUserId, post: widget.post);
      setState(() {
        _isLiked = false;
        _likeCount = _likeCount - 1;
      });
    } else {
      //like post
      DatabaseService.likePost(
          currentUserId: widget.currentUserId, post: widget.post);
      setState(() {
        _heartAnim = true;
        _isLiked = true;
        _likeCount = _likeCount + 1;
      });
      Timer(Duration(milliseconds: 350), () {
        setState(() {
          _heartAnim = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ProfileScreen(
                currentUserId: widget.currentUserId,
                userId: widget.post.authorId,
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
                  backgroundImage: widget.author.profileImageUrl.isEmpty
                      ? AssetImage("assets/images/user_placeholder.jpg")
                      : CachedNetworkImageProvider(
                          widget.author.profileImageUrl),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.author.name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: _likePost,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(widget.post.imageUrl),
                        fit: BoxFit.cover)),
              ),
              _heartAnim
                  ? Animator(
                      duration: Duration(microseconds: 300),
                      tween: Tween(begin: 0.5, end: 1.4),
                      curve: Curves.elasticOut,
                      builder: (anim) => Transform.scale(
                        scale: anim.value,
                        child: Icon(
                          Icons.favorite,
                          size: 100,
                          color: Colors.red[400],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: _isLiked
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(Icons.favorite_border,
                        color: Colors.grey,),
                    iconSize: 30,
                    onPressed: _likePost,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_comment,
                      size: 30,
                      color: Colors.grey,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          postId: widget.post.id,
                          likeCount: _likeCount,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  "${_likeCount.toString()} beğenme",
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
                      widget.author.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.post.caption,
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
