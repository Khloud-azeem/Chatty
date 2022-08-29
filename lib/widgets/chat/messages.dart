import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Messages extends StatefulWidget {
  Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _user = FirebaseAuth.instance.currentUser;

  // Future<String> getPhotoUrl() async {
  //   final photoUrl = await FirebaseStorage.instance
  //       .ref()
  //       .child("user_images")
  //       .child("${_user!.uid}.jpg")
  //       .getDownloadURL();
  //   return photoUrl;
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return _user != null
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/messages')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> msgsSnapShot) {
              if (msgsSnapShot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                  reverse: true,
                  itemCount: msgsSnapShot.data!.docs.length,
                  itemBuilder: ((BuildContext context, int index) {
                    var senderId = msgsSnapShot.data!.docs[index].get('userId');
                    var isMe = senderId == _user!.uid;
                    var data = msgsSnapShot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              textDirection:
                                  isMe ? TextDirection.rtl : TextDirection.ltr,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                // Expanded(
                                  // child:
                                   FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection('/users')
                                          .doc(senderId)
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>>>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          return CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            backgroundImage: Image.network(
                                              snapshot.data!['photoUrl'],
                                              fit: BoxFit.contain,
                                            ).image,
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                // ),
                                Expanded(
                                  flex: 7,
                                  child: BubbleSpecialThree(
                                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    text: data.get('text'),
                                    color: isMe
                                        ? Theme.of(context).primaryColor
                                        : Colors.blueGrey,
                                    tail: true,
                                    // bubbleRadius: 19,
                                    isSender: isMe,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: isMe
                                ? EdgeInsets.only(right: 5)
                                : EdgeInsets.only(left: 5),
                            child: Text(
                              data.get('username'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    );
                  }));
            },
          )
        : Container(child: CircularProgressIndicator());
  }
}
