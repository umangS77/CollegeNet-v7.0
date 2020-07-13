import 'package:collegenet/models/users.dart';
import 'package:collegenet/pages/announcementpage.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/services/auth.dart';
import 'package:collegenet/services/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collegenet/widgets/announcementpost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/loading.dart';

QuerySnapshot snapshot;
String init = "";
int cnt = 0;
String pageName = "";

class Announcements extends StatefulWidget {
  Announcements({
    this.auth,
    this.onSignedOut,
    this.user,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  final User user;
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  String college = currentUser.college;
  bool isLoading = false;
  List<AnnouncementPost> posts = [];
  TextEditingController searchControl = TextEditingController();
  getAnnouncementPosts() async {
    setState(() {
      isLoading = true;
    });
    snapshot = await announcementRef
        .where("college", isEqualTo: currentUser.college)
        .getDocuments();
    setState(() {
      isLoading = false;
      init = "";
    });
  }

  rebuildannouncements() {
    getAnnouncementPosts();
    setState(() {
      init = "";
    });
  }

  buildannouncementposts(String query) {
    posts.clear();
    query = query.toLowerCase();
    List<Widget> announcementposts = [];
    List<DocumentSnapshot> list = [], l = snapshot.documents;
    if (query != "") {
      list.clear();
      String cap;
      for (var i = 0; i < l.length; i++) {
        cap = l[i].data['caption'].toString().toLowerCase();
        if (cap.contains(query)) {
          list.add(l[i]);
        }
      }
    } else {
      list = l;
    }
    for (var i = 0; i < list.length; i++) {
      posts.add(AnnouncementPost(
        caption: list[i].data['caption'],
        college: list[i].data['college'],
        content: list[i].data['content'],
        postid: list[i].data['postid'],
        userId: list[i].data['userId'],
        username: list[i].data['username'],
        target: list[i].data['target'],
        rebuild: rebuildannouncements,
      ));
    }
    announcementposts.clear();
    if (posts.length == 0) {
      announcementposts.add(SizedBox(
        height: 40,
      ));
      announcementposts.add(Center(
        child: Text(
          "No Results found for the query",
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 20.0,
          ),
        ),
      ));
    } else {
      announcementposts.add(SizedBox(
        height: 20,
      ));
    }
    for (var i = 0; i < posts.length; i++) {
      if (posts[i] != null) {
        announcementposts.add(posts[i]);
        // print(posts[i].caption);
      }
    }
    return Column(
      children: announcementposts,
    );
  }

  handlePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) => AddAnnouncement(
              rebuild: rebuildannouncements,
            ));
  }

  @override
  void initState() {
    super.initState();
    cnt = 0;
    getAnnouncementPosts();
    pageName = "College Announcements";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe2ded3),
      appBar: AppBar(
        backgroundColor: Color(0xff1a2639),
        title: Text(
          pageName,
          style: TextStyle(
            fontFamily: 'Chelsea',
            // fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? circularProgress()
          : Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: buildannouncementposts(init),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
        foregroundColor: Colors.orange,
        onPressed: () {
          handlePost(context);
        },
      ),
    );
  }
}
