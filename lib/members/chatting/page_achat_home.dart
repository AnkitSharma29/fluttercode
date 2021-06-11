import 'package:flutter/material.dart';
import 'package:mbo/classes/Chat_Contacts.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/main.dart';
import 'package:mbo/members/chatting/page_chat_add_individual.dart';
import 'package:mbo/wedgits/settings.dart';

import 'page_chat_group_add.dart';

class ChatHomePage extends StatefulWidget {
  final MyUser currentUser;
  ChatHomePage({this.currentUser, Key key}) : super(key: key);

  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  getChatListContacts() {
    return StreamBuilder(
      stream: instantChattingRef
          .where('chtGroup', arrayContainsAny: [widget.currentUser.usrId])
          .orderBy('chtLastTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.documents.length <= 0) {
          return Center(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: bgGray,
                  style: BorderStyle.solid,
                  width: 1.0,
                ),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Text(
                'لا توجد سجلات',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        List<ChatContacts> chatMasseges = [];
        snapshot.data.documents.forEach((doc) {
          if (doc.data()['chtGroupType'] >= 0)
            chatMasseges
                .add(ChatContacts.fromDocument(doc, widget.currentUser));
        });
        return Column(
          children: chatMasseges,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الدردشة الفورية'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatAddIndividualPage(
                    currentUser: widget.currentUser,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.supervised_user_circle,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatAddGroupPage(
                    currentUser: widget.currentUser,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.all(
              15.0,
            ),
            child: getChatListContacts(),
          ),
        ),
      ),
    );
  }
}
