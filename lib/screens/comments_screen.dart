import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_application/models/comment.dart';
import 'package:instagram_application/models/user.dart';
import 'package:instagram_application/models/user.data.dart';
import 'package:instagram_application/services/database_service.dart';
import 'package:instagram_application/utilities/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;
  final int likeCount;

  CommentsScreen({this.postId, this.likeCount});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;

  _buildComment(Comment comment) {
    return FutureBuilder(
      future: DatabaseService.getUserWithId(comment.authorId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        User author = snapshot.data;
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
            backgroundImage: author.profileImageUrl.isEmpty
                ? AssetImage("assets/images/user_placeholder.jpg")
                : CachedNetworkImageProvider(author.profileImageUrl),
          ),
          title: Text(
            author.name,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                comment.content,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                DateFormat.yMd().add_jm().format(
                      comment.timestamp.toDate(),
                       ),
                       style: TextStyle(
                         fontWeight: FontWeight.w400
                       ),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildCommentTF() {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return IconTheme(
      data: IconThemeData(
          color: _isCommenting
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height*1/16,
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: _commentController,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (comment) {
                    setState(() {
                      _isCommenting = comment.length > 0;
                    });
                  },
                  decoration: InputDecoration(
                    border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    hintText: "Bir yorum yaz...",
                    hintStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400
                    ),
                    
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: IconButton(
                icon: Icon(Icons.send,
                size: 30,
                color: Theme.of(context).accentColor,),
                onPressed: () {
                  if (_isCommenting) {
                    DatabaseService.commentOnPost(
                        currentUserId: currentUserId,
                        postId: widget.postId,
                        comment: _commentController.text);
                    _commentController.clear();
                    setState(() {
                      _isCommenting = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Yorumlar",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              '${widget.likeCount} Beğenme',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          StreamBuilder(
            stream: commentsRef
                .document(widget.postId)
                .collection('postComments')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    Comment comment =
                        Comment.fromDoc(snapshot.data.documents[index]);
                    return _buildComment(comment);
                  },
                ),
              );
            },
          ),
          Divider(
            height: 1,
          ),
          _buildCommentTF()
        ],
      ),
    );
  }
}
