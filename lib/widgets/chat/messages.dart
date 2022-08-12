import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  Messages({Key? key}) : super(key: key);
  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return _user != null
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/messages')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                  reverse: true,
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: ((BuildContext context, int index) {
                    var isSender =
                        streamSnapshot.data!.docs[index].get('userId') ==
                            _user!.uid;
                    var data = streamSnapshot.data!.docs[index];
                    return Column(
                      children: [
                        // Text(
                        //   data.get('username'),
                        //   style: TextStyle(fontWeight: FontWeight.bold),
                        //   textAlign: isSender ? TextAlign.end : TextAlign.start,
                        // ),
                        BubbleNormal(
                          text: data.get('text'),
                          color: isSender
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          tail: true,
                          isSender: isSender,
                        ),
                      ],
                    );
                  }));
            },
          )
        : Container(child: CircularProgressIndicator());
  }
}
