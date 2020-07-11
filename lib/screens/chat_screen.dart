import '../chat/new_message.dart';
import 'package:flutter/material.dart';
import '../chat/messages.dart';
import '../widgets/app_drawer.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      drawer: AppDrawer(),
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
