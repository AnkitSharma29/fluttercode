import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/classes/date_formatter.dart';
import 'package:mbo/members/chatting/page_chat_chatting.dart';
import 'package:mbo/wedgits/cashImages.dart';
import 'package:mbo/wedgits/settings.dart';

class ChatContacts extends StatelessWidget {
  final String chtId;
  final String chtOwner;
  final String chtName;
  final String chtImage;
  final List chtGroup;
  final List chtGroupUsers;
  final int chtGroupType;
  final Timestamp chtLastTime;
  final MyUser currentUser;
  final bool usrOnline;
  ChatContacts({
    this.chtId,
    this.chtOwner,
    this.chtName,
    this.chtImage,
    this.chtGroup,
    this.chtGroupUsers,
    this.chtGroupType,
    this.chtLastTime,
    this.currentUser,
    this.usrOnline,
  });

  factory ChatContacts.fromDocument(DocumentSnapshot doc, MyUser currentUser) {
    String chtName = '';
    String chtImage = '';
    bool usrOnline = false;
    //List chtGroup = doc.data()['chtGroup'];
    List chtGroupUsers = doc.data()['chtGroupUsers'];

    if (doc.data()['chtGroupType'] == 0) {
      //chtGroup.removeAt(index) .removeWhere((k, v) => k == currentUserId);
      chtGroupUsers.forEach((element) {
        if (element['usrId'] != currentUser.usrId) {
          chtName = element['usrName'];
          chtImage = element['usrImage'];
          usrOnline = element['usrOnline'];
          //print(element['usrName']);
        }
        //print(element.toString());
      });
    } else {
      chtName = doc.data()['chtName'];
      chtImage = doc.data()['chtImage'];
    }
    // print(chtImage);
    return ChatContacts(
      chtId: doc.id,
      chtOwner: doc.data()['chtOwner'],
      chtName: chtName,
      chtImage: chtImage,
      chtGroupType: doc.data()['chtGroupType'],
      chtGroup: doc.data()['chtGroup'],
      chtGroupUsers: doc.data()['chtGroupUsers'],
      chtLastTime: doc.data()['chtLastTime'],
      currentUser: currentUser,
      usrOnline: usrOnline,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: (chtGroupType == 0) ? bgGray : lightGreen,
      child: ListTile(
        title: Text(chtName),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChattingPage(
              chtId: chtId,
              chtGroup: chtGroup,
              chtGroupUsers: chtGroupUsers,
              chtName: chtName,
              chtOwner: chtOwner,
              chtGroupType: chtGroupType,
              chtImage: chtImage,
              currentUser: currentUser,
            ),
          ),
        ),
        leading: SizedBox(
          width: 40.0,
          height: 40.0,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 45.0,
            backgroundImage: AssetImage('assets/images/logo.png'),
            child: myCachedNetworkImage(chtImage,
                myBorderRadius: 50.0,
                defualtImage: (chtImage == null)
                    ? (chtGroupType == 1)
                        ? 'Group-icon.png'
                        : null
                    : null),
          ),
        ),
        trailing:
            (chtGroupType == 1) ? Icon(Icons.supervised_user_circle) : null,
        subtitle: Text(
          timestampTodate(chtLastTime) + ' - ' + timestampTotime(chtLastTime),
          style: TextStyle(
            fontFamily: englishFont,
            fontSize: 11.0,
          ),
        ),
      ),
    );
  }
}
