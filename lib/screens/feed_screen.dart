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
        /*
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            children: <Widget>[
              Text(
                "Instagram",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Billabong",
                    fontSize: 35,
                    fontWeight: FontWeight.w300),
              ),
              Divider(
                height: 1,
              ),
              Text(
                "Instagram",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Billabong",
                    fontSize: 35,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
         
        ), */
        appBar: AppBar(
          elevation: 1.0,
          backgroundColor: Colors.grey[50],
          title: Row(
            children: <Widget>[
              Builder(builder: (BuildContext context) {
                return GestureDetector(
                    child:
                        Icon(Icons.camera_alt, color: Colors.black, size: 32.0),
                    onTap: () {} // => showSnackbar(context, 'Add Photo'),
                    );
              }),
              SizedBox(width: 12.0),
              GestureDetector(
                  child: Text(
                    'Instagram',
                    style: TextStyle(
                        fontFamily: 'Billabong',
                        color: Colors.black,
                        fontSize: 32.0),
                  ),
                  onTap: () {} // _scrollToTop,
                  ),
            ],
          ),
          actions: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.live_tv),
                  onPressed: () {},
                  //   onPressed: () => showSnackbar(context, 'Live TV'),
                );
              },
            ),
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.near_me), //nearMe,
                  onPressed: () {},
                  //onPressed: () => showSnackbar(context, 'My Messages'),
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
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
        ));
  }
}
