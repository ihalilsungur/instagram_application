
import 'package:flutter/material.dart';
import 'package:instagram_application/models/post.dart';
import 'package:instagram_application/models/user.dart';
import 'package:instagram_application/services/database_service.dart';
import 'package:instagram_application/widgets/post_view.dart';

class FeedScreen extends StatefulWidget {
  static final String id = "feed_screen";
  final String currentUserId;
  FeedScreen({
    this.currentUserId,
  });

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = [];
  @override
  void initState() {
    super.initState();
    _setupFeed();
  }

  _setupFeed() async {
    List<Post> posts = await DatabaseService.getFeedPost(widget.currentUserId);
    setState(() {
      _posts = posts;
    });
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
      body:  RefreshIndicator(
              onRefresh: () => _setupFeed(),
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (BuildContext context, int index) {
                  Post post = _posts[index];
                  return FutureBuilder(
                    future: DatabaseService.getUserWithId(post.authorId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox.shrink();
                      }
                      User author = snapshot.data;
                      return PostView(
                        currentUserId: widget.currentUserId,
                        post: post,
                        author: author,
                      );
                    },
                  );
                },
              ),
            )
    );
  }
}
