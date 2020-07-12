import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegenet/pages/cabsharing.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:flutter/material.dart';

class CabPosts extends StatefulWidget {
  CabPosts({
    this.postId,
    this.username,
    this.count,
    this.userId,
    this.college,
    this.destination,
    this.source,
    this.leavetime,
    this.facebook,
    this.contact,
    this.users,
    this.rebuild,
  });
  final Timestamp leavetime;
  final String postId;
  final String username;
  final String destination;
  final String college;
  final String source;
  final String facebook;
  final String contact;
  final String userId;
  final int count;
  final String users;
  final VoidCallback rebuild;

  factory CabPosts.fromDocument(DocumentSnapshot doc) {
    return new CabPosts(
      postId: doc['postId'],
      userId: doc['userId'],
      username: doc['username'],
      destination: doc['destination'],
      source: doc['source'],
      facebook: doc['facebook'],
      college: doc['college'],
      count: doc['count'],
      leavetime: doc['leavetime'],
      contact: doc['contact'],
      users: doc['users'],
    );
  }
  @override
  _CabPostsState createState() => _CabPostsState();
}

class _CabPostsState extends State<CabPosts> {
  var temp;
  var randnum;
  String filepath;
  bool isOwner;
  String date;
  String time;
  String minu;
  String hou;
  List<String> mon = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  deleteFilePost() async {
    await cabPostsRef.document(widget.postId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    widget.rebuild();
  }

  handleDeleteFilePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  deleteFilePost();
                },
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              // SimpleDialogOption(
              //   onPressed: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => EditPost(
              //                 postId: widget.postId,
              //                 caption: widget.caption,
              //                 content: widget.content,
              //                 mediaUrl: widget.mediaUrl,
              //                 isLocal: widget.isLocal,
              //                 isFile: widget.isFile,
              //                 fileExtension: widget.fileExtension,
              //               )),
              //     );
              //   },
              //   child: Text(
              //     "Edit",
              //     style: TextStyle(color: Colors.red),
              //   ),
              // ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }

  buildPostHeader() {
    if (widget.leavetime.toDate().toLocal().minute < 10) {
      minu = '0' + widget.leavetime.toDate().toLocal().minute.toString();
    } else {
      minu = widget.leavetime.toDate().toLocal().minute.toString();
    }
    if (widget.leavetime.toDate().toLocal().hour < 10) {
      hou = '0' + widget.leavetime.toDate().toLocal().hour.toString();
    } else {
      hou = widget.leavetime.toDate().toLocal().hour.toString();
    }
    time = hou + " : " + minu;
    date = widget.leavetime.toDate().toUtc().day.toString() +
        "-" +
        mon[widget.leavetime.toDate().toUtc().month] +
        "-" +
        widget.leavetime.toDate().toUtc().year.toString();
    isOwner = (widget.userId == currentUser.id);
    return Material(
      color: Colors.white.withOpacity(0.65),
      borderRadius: BorderRadius.circular(24),
      shadowColor: Colors.amber.withOpacity(0.9),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.amberAccent[100],
                  Colors.amberAccent[200],
                  Colors.amber,
                  Colors.amberAccent[200],
                  Colors.amberAccent[100],
                ]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: Colors.yellow,
                spreadRadius: 1,
                offset: Offset(9, 0),
              ),
              BoxShadow(
                blurRadius: 15,
                color: Colors.white,
                spreadRadius: 1,
                offset: Offset(-4, 0),
              )
            ]),
        // padding: EdgeInsets.all(50),
        width: MediaQuery.of(context).size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(22)),
                ),
                height: 70.0,
                width: MediaQuery.of(context).size.width,
                child: ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(filepath),
                      radius: 25,
                    ),
                  ),
                  title: Text(
                    widget.username.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(5),
                  dense: true,
                  trailing: isOwner
                      ? IconButton(
                          color: Colors.amber,
                          icon: Icon(Icons.more_vert),
                          onPressed: () => handleDeleteFilePost(context))
                      : Text(''),
                ),
              ),
              Divider(color: Colors.black),
              Material(
                  color: Colors.white.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.center,
                        child: Text(
                          date,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  )),
              Divider(
                color: Colors.black,
              ),
              Row(children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 30, right: 10),
                    height: 120,
                    alignment: Alignment(0, -0.45),
                    child: CustomPaint(
                      painter: LocPainter(),
                    )),
                Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(border: Border.all()),
                            child: Text(widget.source)),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(border: Border.all()),
                            child: Text(
                              widget.destination,
                            )),
                      ],
                    )),
              ]),
              Material(
                  color: Colors.white.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(24),
                  child: Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Text(
                        "Leaving Around :-" + "   " + time,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ])),
              Divider(
                color: Colors.black,
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("Already Going: " + "  " + widget.count.toString()),
                    RaisedButton.icon(
                      color: Colors.black,
                      onPressed: null,
                      icon: Icon(
                        Icons.add_box,
                        color: Colors.black87,
                      ),
                      label: Text(
                        "Join Group",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
              ),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    temp = widget.userId.codeUnitAt(0);
    randnum = 1 + (temp - 48);
    temp = randnum.ceil();
    filepath = 'assets/images/avatars/av$temp.png';
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildPostHeader(),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

class LocPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    final paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 3;

    canvas.drawOval(Rect.fromLTWH(0, 0, 10, 10), paint);
    canvas.drawLine(
      Offset(5, 5),
      Offset(5, 48),
      paint1,
    );
    canvas.drawOval(Rect.fromLTWH(0, 46, 10, 10), paint);
  }

  @override
  bool shouldRepaint(LocPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(LocPainter oldDelegate) => false;
}
