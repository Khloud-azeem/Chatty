import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('messages').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (!streamSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: ((BuildContext context, int index) {
                return Center(
                    child: Text(
                  streamSnapshot.data!.docs[index].data().toString(),
                ));
              }));
        },
      ),
    );
  }
}
