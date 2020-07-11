import 'dart:io';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/services/loading.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementPost extends StatefulWidget {
  final String postid;
  final String userId;
  final String username;
  final String caption;
  final String content;
  final String college;
  final String target;
  AnnouncementPost({
    this.postid,
    this.userId,
    this.username,
    this.caption,
    this.content,
    this.college,
    this.target,
  });
  factory AnnouncementPost.fromDocument(DocumentSnapshot doc) {
    return new AnnouncementPost(
      postid: doc['postid'],
      userId: doc['userId'],
      username: doc['username'],
      caption: doc['caption'],
      content: doc['content'],
      college: doc['college'],
      target: doc['target'],
    );
  }
  @override
  _AnnouncementPostState createState() => _AnnouncementPostState();
}

class _AnnouncementPostState extends State<AnnouncementPost> {
  String details;
  bool isAnnouncementPostOwner;
  int temp;
  String percentage;
  double randnum = 1;

  buildAnnouncementTile() {
    isAnnouncementPostOwner = (userId == currentUser.id);
    details = widget.content;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.green[200], Colors.blue[200]]),
//          color: Colors.black,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.greenAccent,
                  spreadRadius: 1,
                  offset: Offset(4, 4),
                ),
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.white,
                  spreadRadius: 1,
                  offset: Offset(-4, -4),
                )
              ]),
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              color: Colors.white.withOpacity(0.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 60.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xff2d4059),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(22)),
                      ),
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.speaker_notes),
                        ),
                        title: Text(
                          widget.caption.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(6),
                        dense: true,
                        trailing: isAnnouncementPostOwner
                            ? IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.orange,
                                onPressed: () =>
                                    handleDeleteAnnouncement(context))
                            : Text(''),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 182,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, right: 2, left: 2),
                        child: Text(
                          widget.content,
                          style: TextStyle(
                            color: Colors.black,
//                              fontWeight: FontWeight.bold,
                            fontFamily: 'Chelsea',
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  deleteAnnouncementPost() {
    announcementRef.document(widget.postid).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    userWisePostsRef
        .document(userId)
        .collection("announcements")
        .document(widget.postid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleDeleteAnnouncement(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Delete this announcement ?"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  deleteAnnouncementPost();
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    //  getUserById();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    temp = widget.userId.codeUnitAt(0);
    randnum = 1 + (temp - 48) / 12;
    temp = randnum.ceil();
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildAnnouncementTile(),
        ],
      ),
    );
  }
}
