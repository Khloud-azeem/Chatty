import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _enteredMsg = '';
  final _controller = TextEditingController();
    final _auth = FirebaseAuth.instance;

  Future<String> getPhotoUrl() async {
    final photoUrl = await FirebaseStorage.instance
        .ref()
        .child("user_images")
        .child("${_auth.currentUser!.uid}.jpg")
        .getDownloadURL();
    return photoUrl;
  }

  void _sendMsg() async {
    final _userData = await FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    _controller.clear();

    FirebaseFirestore.instance.collection('/messages').add({
      "text": _enteredMsg,
      "createdAt": Timestamp.now(),
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "username": _userData.data()!['username'],
    });
    setState(() {
      _enteredMsg = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 9),
      padding: EdgeInsets.all(9),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              decoration: InputDecoration(hintText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMsg = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMsg.isEmpty ? null : _sendMsg,
            icon: Icon(
              Icons.send,
              color: _enteredMsg.isEmpty
                  ? Colors.grey
                  : Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
