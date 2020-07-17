import 'package:collegenet/services/auth.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/pages/loginsignup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;

  MappingPage({
    this.auth,
  });
  _MappingPageState createState() => _MappingPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _MappingPageState extends State<MappingPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId) {
      setState(() {
        authStatus = (firebaseUserId == null)
            ? AuthStatus.notSignedIn
            : AuthStatus.signedIn;
      });
    });
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print("a");
      print(msg);
      Navigator.of(context).pushReplacementNamed('/');
      return;
    }, onLaunch: (msg) async {
      pageIndex = int.parse(msg['data']['screen']);
      return;
    }, onResume: (msg) async {
      print("dawdawd");
      pageIndex = int.parse(msg['data']['screen']);
      print(pageIndex);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            auth: widget.auth,
            onSignedOut: _signOut,
            pageIndex: pageIndex,
          ),
        ),
      );
      print(msg);
      return;
    });
    fbm.getToken().then((token) {
      update(token);
    });
  }

  update(String token) {
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/${token}').set({"token": 0});
    setState(() {});
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginSignupPage(auth: widget.auth, onSignedIn: _signedIn);
      case AuthStatus.signedIn:
        return new HomePage(
          auth: widget.auth,
          onSignedOut: _signOut,
          pageIndex: pageIndex,
        );
    }
    return null;
  }
}
