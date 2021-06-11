import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/classes/date_formatter.dart';
import 'package:mbo/main.dart';
import 'package:mbo/wedgits/cashImages.dart';
import 'package:mbo/wedgits/settings.dart';
import 'package:mbo/wedgits/veiw_Image.dart';
import 'package:uuid/uuid.dart';

import 'page_chat_group_edit.dart';
import 'page_chat_members.dart';

class Choice {
  const Choice({this.func, this.title, this.icon});
  final int func;
  final String title;
  final IconData icon;
}

class ChattingPage extends StatefulWidget {
  final String chtId;

  final List chtGroup;
  final List chtGroupUsers;
  final String chtName;
  final String chtOwner;
  final int chtGroupType;
  final String chtImage;
  final MyUser currentUser;

  ChattingPage(
      {this.chtId,
      this.chtGroup,
      this.chtGroupUsers,
      this.chtGroupType,
      this.chtImage,
      this.chtName,
      this.chtOwner,
      this.currentUser,
      Key key})
      : super(key: key);

  @override
  _ChattingPageState createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  bool isShowSticker = false;
  var listMessage;
  //final AuthFunc auth = new EmailAuth();
  String currentUserId;
  File imageFile;
  bool isLoading = false;
  String imageUrl = '';
  List<Choice> choices = [];

  bool _onlineStatus = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getTargetUserOnlineStatus();
  }

  getTargetUserOnlineStatus() {
    String targetUsrId;
    if (widget.chtGroupType == 0 && targetUsrId == null) {
      //print(widget.chtGroupUsers.toString());
      //chtGroup.removeAt(index) .removeWhere((k, v) => k == currentUserId);
      widget.chtGroupUsers
        ..forEach((element) {
          if (element['usrId'] != widget.currentUser.usrId) {
            targetUsrId = element['usrId'];
            //print(element['usrName']);
          }
        });

      usersRef.doc(targetUsrId).snapshots().listen((document) {
        MyUser targetCurrentUser = MyUser.fromDocument(document);
        if (document.exists) {
          if (mounted == true) {
            setState(() {
              _onlineStatus = targetCurrentUser.usrOnline;
            });
          }
        } else {
          if (mounted == true) {
            setState(() {
              _onlineStatus = false;
            });
          }
        }
      });

      _onlineStatus = true;
    }
  }

  getChatUser(usrId) {
    String usrImage;
    String usrName;

    int userIndex = widget.chtGroupUsers.indexWhere((f) => f['usrId'] == usrId);
    if (userIndex >= 0) {
      usrImage = widget.chtGroupUsers[userIndex]['usrImage'];
      usrName = widget.chtGroupUsers[userIndex]['usrName'];
    } else {
      usrImage = null;
      usrName = null;
    }

    //print(usrImage); // Output you will get is 1
    //print(usrName);

    return {'usrImage': usrImage, 'usrName': usrName};
  }

  getCurrentUser() async {
    currentUserId = widget.currentUser.usrId;
  }

  List<Choice> choicesGroupOwner = const <Choice>[
    const Choice(
        func: 1, title: 'معلومات المجموعة', icon: Icons.supervised_user_circle),
    const Choice(func: 2, title: 'تعديل المعلومات', icon: Icons.edit),
  ];

  List<Choice> choicesGroupMember = const <Choice>[
    const Choice(
        func: 1, title: 'معلومات المجموعة', icon: Icons.supervised_user_circle),
  ];

  void onItemMenuPress(Choice choice) {
    switch (choice.func) {
      //Owner Edit Chat Groub Page
      case 1:
      case 3:
        // print(widget.chtGroupUsers);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatMembersPage(
              currentUser: widget.currentUser,
              chtId: widget.chtId,
              chtGroup: widget.chtGroup,
              chtGroupUsers: widget.chtGroupUsers,
              chtName: widget.chtName,
              chtOwner: widget.chtOwner,
              chtImage: widget.chtImage,
              chtGroupType: widget.chtGroupType,
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatEditGroupPage(
              currentUser: widget.currentUser,
              chtId: widget.chtId,
              chtGroup: widget.chtGroup,
              chtGroupUsers: widget.chtGroupUsers,
              chtName: widget.chtName,
              chtOwner: widget.chtOwner,
              chtImage: widget.chtImage,
              chtGroupType: widget.chtGroupType,
            ),
          ),
        );
        break;
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['msgOwner'] == currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['msgOwner'] != currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future getImage() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    setState(() {
      if (pickedFile != null) {
        //chtImage = File(pickedFile.path);
        isLoading = true;
        uploadFile(File(pickedFile.path));
      } else {
        isLoading = false;
      }
    });
  }

  Future uploadFile(imageFile) async {
    // String imgId = Uuid().v4();
    // StorageUploadTask uploadTask =
    //     storageRef.child("messages/msg_$imgId.jpg").putFile(imageFile);
    // StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    // String downloadUrl = await storageSnap.ref.getDownloadURL();
    // setState(() {
    //   isLoading = false;
    //   onSendMessage(downloadUrl, 1);
    // });

    String imgId = Uuid().v4();
    UploadTask uploadTask =
        storageRef.child("messages/mem_msg_$imgId.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageSnap.ref.getDownloadURL();

    setState(() {
      isLoading = false;
      onSendMessage(downloadUrl, 1);
    });

    return downloadUrl;
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    Timestamp _timestamp = Timestamp.now();
    //Timestamp _timestamp = DateTime.now();

    if (content.trim() != '') {
      textEditingController.clear();

      switch (type) {
        case 0:
          instantChattingRef.doc(widget.chtId).collection('masseges').add({
            'msgServerTime': FieldValue.serverTimestamp(),
            'msgDateTime': _timestamp,
            'msgOwner': currentUserId,
            'msgText': content,
            'msgType': type,
            'msgFace': null,
            'msgImage': null,
          }).catchError((onError) {
            //print(onError.toString());
          });
          break;

        case 1:
          instantChattingRef.doc(widget.chtId).collection('masseges').add({
            'msgServerTime': FieldValue.serverTimestamp(),
            'msgDateTime': _timestamp,
            'msgOwner': currentUserId,
            'msgText': null,
            'msgType': type,
            'msgFace': null,
            'msgImage': content,
          }).catchError((onError) {
            //print(onError.toString());
          });
          break;

        case 2:
          instantChattingRef.doc(widget.chtId).collection('masseges').add({
            'msgServerTime': FieldValue.serverTimestamp(),
            'msgDateTime': _timestamp,
            'msgOwner': currentUserId,
            'msgText': null,
            'msgType': type,
            'msgFace': content,
            'msgImage': null,
          }).catchError((onError) {
            //print(onError.toString());
          }).whenComplete(() => getSticker());

          break;
      }
      instantChattingRef.doc(widget.chtId).update({
        'chtLastTime': _timestamp,
      }).whenComplete(() => listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut));
    } else {
      //Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      //   Firestore.instance.collection('users').document(id).updateData({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.chtName),
            (widget.chtGroupType == 0)
                ? Icon(
                    Icons.circle,
                    color: (_onlineStatus == true) ? Colors.green : Colors.grey,
                    size: 12.0,
                  )
                : Container(
                    width: 0.0,
                    height: 0.0,
                  ),
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              if (widget.chtGroupType == 1 &&
                  widget.chtOwner == currentUserId) {
                choices = choicesGroupOwner;
              } else {
                choices = choicesGroupMember;
              }
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          choice.title,
                          style: TextStyle(color: Color(0xff203152)),
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Icon(
                          choice.icon,
                          color: Colors.blue,
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),
                // Sticker
                (isShowSticker
                    ? buildSticker()
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      )),
                // Input content
                buildInput(),
              ],
            ),

            // Loading
            buildLoading()
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xfff5a623))),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: widget.chtId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623))))
          : StreamBuilder(
              stream: instantChattingRef
                  .doc(widget.chtId)
                  .collection('masseges')
                  .orderBy('msgServerTime', descending: true)
                  .limit(50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xfff5a623),
                      ),
                    ),
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
                        'لا توجد محادثات',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                listMessage = snapshot.data.documents;
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) =>
                      buildItem(index, snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                  reverse: true,
                  controller: listScrollController,
                );
              },
            ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    double width = MediaQuery.of(context).size.width;
    String msgOwner =
        (document['msgOwner'] != null) ? document['msgOwner'] : null;
    int msgType = (document['msgType'] != null) ? document['msgType'] : null;
    String msgText =
        (document['msgText'] != null && (document['msgText']).isNotEmpty)
            ? document['msgText']
            : '';
    String msgImage =
        (document['msgImage'] != null && (document['msgImage']).isNotEmpty)
            ? document['msgImage']
            : null;
    String msgFace =
        (document['msgFace'] != null && (document['msgFace']).isNotEmpty)
            ? document['msgFace']
            : null;
    Timestamp msgDateTime = (document['msgDateTime'] != null)
        ? document['msgDateTime']
        : Timestamp.now();
    Map chatUser;
    String chatUsrImg;
    String chatUsrName = 'غير معروف';

    if (msgOwner == currentUserId) {
      // Right (my message)
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                (msgType == 0)
                    ? Container(
                        child: Text(
                          msgText,
                          style: TextStyle(
                            color: Color(0xff203152),
                          ),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: (width / 3) * 2,
                        decoration: BoxDecoration(
                            color: bgGray,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 5.0 : 5.0,
                            right: 10.0),
                      )
                    : (msgType == 1)
                        ? GestureDetector(
                            child: Container(
                              height: (width / 4) * 2,
                              width: (width / 4) * 2,
                              child: myCachedNetworkImage(
                                msgImage,
                                myBorderRadius: 10,
                              ),
                              margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 5.0 : 5.0,
                                right: 10.0,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowImagePage(
                                    imgUrl: msgImage,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            child: new Image.asset(
                              'assets/images/chatIcons/$msgFace.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 10.0 : 10.0,
                              right: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
              ],
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    timestampTodate(msgDateTime) +
                        ' - ' +
                        timestampTotime(msgDateTime),
                    style: TextStyle(
                      color: Color(0xffaeaeae),
                      fontSize: 11.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: englishFont,
                    ),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              margin: EdgeInsets.only(right: 20.0, top: 5.0, bottom: 5.0),
            ),
          ],
        ),
      );
    } else {
      chatUser = getChatUser(msgOwner);
      chatUsrImg = chatUser['usrImage'];
      chatUsrName = (chatUser['usrName'] != null &&
              chatUser['usrName'].toString().isNotEmpty)
          ? chatUser['usrName']
          : 'غير معروف';
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                setMessageOwnerImage(chatUsrImg),
                (msgType == 0)
                    ? Container(
                        child: Text(
                          msgText,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: (width / 3) * 2,
                        decoration: BoxDecoration(
                          color: masterBlue,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : (msgType == 1)
                        ? GestureDetector(
                            child: Container(
                              height: (width / 4) * 2,
                              width: (width / 4) * 2,
                              child: myCachedNetworkImage(
                                msgImage,
                                myBorderRadius: 10,
                              ),
                              margin: EdgeInsets.only(left: 10.0),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowImagePage(
                                    imgUrl: msgImage,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            child: Image.asset(
                              'assets/images/chatIcons/$msgFace.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 5.0 : 5.0,
                              right: 10.0,
                              left: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
              ],
            ),

            Container(
              width: (width / 4) * 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    timestampTodate(msgDateTime) +
                        ' - ' +
                        timestampTotime(msgDateTime),
                    style: TextStyle(
                      color: Color(0xffaeaeae),
                      fontSize: 11.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: englishFont,
                    ),
                  ),
                  Text(
                    chatUsrName,
                    style: TextStyle(
                      color: Color(0xffaeaeae),
                      fontSize: 11.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: arabicFont,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            ),
            //: Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Color(0xff203152), fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'اكتب رسالتك ...',
                  hintStyle: TextStyle(color: Color(0xffaeaeae)),
                ),
                focusNode: focusNode,
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, 0);
                },
              ),
            ),
          ),

          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: getImage,
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face),
                onPressed: getSticker,
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: Color(0xffE8E8E8), width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: new Image.asset(
                  'assets/images/chatIcons/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: new Image.asset(
                  'assets/images/chatIcons/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: new Image.asset(
                  'assets/images/chatIcons/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: new Image.asset(
                  'assets/images/chatIcons/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: new Image.asset(
                  'assets/images/chatIcons/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: new Image.asset(
                  'assets/images/chatIcons/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: new Image.asset(
                  'assets/images/chatIcons/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: new Image.asset(
                  'assets/images/chatIcons/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: new Image.asset(
                  'assets/images/chatIcons/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: Color(0xffE8E8E8), width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  setMessageOwnerImage(chatUsrImg) {
    return (chatUsrImg != null)
        ? Container(
            width: 35.0,
            height: 35.0,
            child: myCachedNetworkImage(chatUsrImg, myBorderRadius: 50.0),
          )
        : CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
            ),
          );
  }
}
