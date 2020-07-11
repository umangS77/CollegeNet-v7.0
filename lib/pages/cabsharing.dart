import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegenet/models/users.dart';
import 'package:collegenet/pages/add_cabsharing.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/services/auth.dart';
import 'package:collegenet/widgets/cabposts.dart';
import 'package:flutter/material.dart';
import '../services/loading.dart';

final cabPostsRef = Firestore.instance.collection("CabPosts");

enum PageType {
  allPosts,
  myPosts,
}
PageType status;
String pageName;
QuerySnapshot snapshot;
String init = "";

class CabSharing extends StatefulWidget {
  CabSharing({
    this.auth,
    this.onSignedOut,
    this.user,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  final User user;
  @override
  _CabSharingState createState() => _CabSharingState();
}

class _CabSharingState extends State<CabSharing> {
  bool isLoading = false;
  List<CabPosts> posts = [];

  buildCabPosts() {
    posts.clear();
    List<Widget> cabposts = [];
    // List<DocumentSnapshot> l = snapshot.documents;

    posts =
        snapshot.documents.map((doc) => CabPosts.fromDocument(doc)).toList();
    for (var i = 0; i < posts.length; i++) {
      if (posts[i] != null) {
        cabposts.add(posts[i]);
        cabposts.add(SizedBox(
          height: 20,
        ));
        // print(posts[i].caption);
      }
    }
    return Column(
      children: cabposts,
    );
    // print(posts[0].whatsapp);
  }

  getCabposts() async {
    setState(() {
      isLoading = true;
    });
    snapshot = await cabPostsRef
        .where("college", isEqualTo: currentUser.college)
        .getDocuments();

    setState(() {
      isLoading = false;
    });
    print(snapshot.documents);
    buildCabPosts();
  }

  @override
  void initState() {
    getCabposts();
    super.initState();
  }

  TextEditingController searchControl = TextEditingController();
  Icon cusIcon = Icon(Icons.search);
  double h = 72;
  Widget cusSearchBar = Text(
    "Cabs",
    style: TextStyle(
      fontFamily: 'Chelsea',
    ),
  );
  Widget filter = Text("");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe2ded3),
      appBar: PreferredSize(
        child: Column(children: <Widget>[
          AppBar(
            backgroundColor: Color(0xff1a2639),
            title: this.cusSearchBar,
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: this.cusIcon,
                  onPressed: () {
                    if (this.cusIcon.icon == Icons.search) {
                      setState(() {
                        h = 120;
                        filter = Container(
                            width: MediaQuery.of(context).size.width,
                            color: Color(0xff1a2639),
                            child: Row(children: <Widget>[
                              RaisedButton.icon(
                                label: Text("Filter"),
                                color: Colors.white,
                                onPressed: () {},
                                icon: Icon(Icons.filter_b_and_w),
                              ),
                            ]));
                        this.cusIcon = Icon(Icons.cancel);
                        this.cusSearchBar = TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: "Search here",
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          controller: searchControl,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            setState(() {
                              init = value;
                            });
                          },
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Lato'),
                        );
                      });
                    } else {
                      setState(() {
                        h = 72;
                        filter = Container(
                          height: 0,
                        );
                        searchControl.clear();
                        this.cusIcon = Icon(Icons.search);
                        this.cusSearchBar = Text(
                          "Cabs",
                          style: TextStyle(
                            fontFamily: 'Chelsea',
                          ),
                        );
                      });
                    }
                  }),
            ],
          ),
          filter,
        ]),
        preferredSize: Size.fromHeight(h),
      ),
      body: isLoading
          ? circularProgress()
          : Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: buildCabPosts(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
        foregroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCab(),
            ),
          );
        },
      ),
    );
  }
}
