import 'package:chatty/widgets/chat/messages.dart';
import 'package:chatty/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    // Firebase.initializeApp();
    return Scaffold(
        appBar: AppBar(
          title: Text('Chats'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: DropdownButton(
                items: [
                  DropdownMenuItem(
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 13),
                          Text('Sign Out'),
                        ],
                      ),
                    ),
                    value: 'sign out',
                  ),
                ],
                onChanged: (itemId) {
                  if (itemId == 'sign out') {
                    FirebaseAuth.instance.signOut();
                  }
                },
                elevation: 5,
                isDense: true,
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ));
  }
}
