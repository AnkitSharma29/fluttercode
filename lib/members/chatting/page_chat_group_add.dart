import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/members/chatting/page_chat_chatting.dart';
import 'package:mbo/wedgits/cashImages.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';

class ChatAddGroupPage extends StatefulWidget {
  final MyUser currentUser;
  ChatAddGroupPage({this.currentUser, Key key}) : super(key: key);

  @override
  _ChatAddGroupPageState createState() => _ChatAddGroupPageState();
}

class _ChatAddGroupPageState extends State<ChatAddGroupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _autoValidate = AutovalidateMode.disabled;
  File chtImageController;
  final chtNameController = TextEditingController();

  String _searchText;
  int _groupNumber = 0;

  List<Map<String, dynamic>> usrLst = [];

  handleChooseGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    setState(() {
      if (pickedFile != null) {
        chtImageController = File(pickedFile.path);
      } else {
        chtImageController = null;
      }
    });
  }

  Future<String> handelUploadIamge(imageFile, imageName) async {
    // StorageUploadTask uploadTask =
    //     storageRef.child("chatting/cht_$imageName.jpg").putFile(imageFile);
    // StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    // String downloadUrl = await storageSnap.ref.getDownloadURL();
    // return downloadUrl;
    UploadTask uploadTask =
        storageRef.child("chatting/mem_$imageName.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  getContactsList({String searchText}) {
    var query;

    if (searchText == null || searchText.isEmpty) {
      query = usersRef.where('usrType', isEqualTo: 1);
    } else {
      query = usersRef
          .where('usrType', isEqualTo: 1)
          .where('usrName', isGreaterThanOrEqualTo: searchText);
    }

    return StreamBuilder(
      stream: query.snapshots(),
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
        List<Widget> lst = [];
        snapshot.data.documents.forEach((doc) {
          if (doc.data()['usrId'] != widget.currentUser.usrId) {
            String usrName = (doc.data()['usrName'] != null)
                ? doc.data()['usrName']
                : 'غير معروف';
            lst.add(
              Card(
                color: (usrLst
                            .where(
                                (usrLst) => usrLst['usrId'] == doc.documentID)
                            .length >
                        0)
                    ? darkGreen
                    : lightGreen,
                child: ListTile(
                  onTap: () {
                    setState(
                      () {
                        (usrLst
                                    .where((usrLst) =>
                                        usrLst['usrId'] == doc.data()['usrId'])
                                    .length ==
                                0)
                            ? usrLst.add(
                                {
                                  'usrId': doc.data()['usrId'],
                                  'usrName': doc.data()['usrName'],
                                  'usrImage': doc.data()['usrImage']
                                },
                              )
                            : usrLst.removeWhere((usrLst) =>
                                usrLst['usrId'] == doc.data()['usrId']);

                        _groupNumber = usrLst.length;
                      },
                    );

                    //print(usrLst);
                  },
                  leading: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: myCachedNetworkImage(
                      doc.data()['usrImage'],
                      myBorderRadius: 50.0,
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        //usrSalutation +
                        usrName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),

                  trailing: Icon(
                    (usrLst
                                .where((usrLst) =>
                                    usrLst['usrId'] == doc.documentID)
                                .length >
                            0)
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: (usrLst
                                .where((usrLst) =>
                                    usrLst['usrId'] == doc.documentID)
                                .length >
                            0)
                        ? Colors.white
                        : Colors.grey,
                  ),

                  //onTap: () => checkIsOnChat(doc),
                ),
              ),
            );
          }
        });
        return Column(
          children: lst,
        );
      },
    );
  }

  handleCreateChatGroup() async {
    int _chtGroupType = 1;
    //var _chtGroup;

    Timestamp _chtLastTime = Timestamp.now();
    String _chtName = chtNameController.text;
    String _chtOwner = widget.currentUser.usrId;

    Dialogs.showLoadingDialog(context, _keyLoader);

    String _chtImage;
    if (chtImageController != null) {
      String imgFileName = Uuid().v4();
      _chtImage = await handelUploadIamge(chtImageController, imgFileName);
    } else {
      _chtImage = null;
    }

    DocumentReference ref = instantChattingRef.doc();
    String _chtId = ref.id;

    List _chtGroup = [];
    List _chtGroupUsers = [];
    for (var usrLstElement in usrLst) {
      //print(usrLstElement['usrId']);
      //print(usrLstElement['usrName']);
      //print(usrLstElement['usrImage']);
      _chtGroup.add(usrLstElement['usrId']);
      _chtGroupUsers.add({
        'usrId': usrLstElement['usrId'],
        'usrName': usrLstElement['usrName'],
        'usrImage': usrLstElement['usrImage'],
      });
    }

    _chtGroup.add(widget.currentUser.usrId);
    _chtGroupUsers.add({
      'usrId': widget.currentUser.usrId,
      'usrName': widget.currentUser.usrName,
      'usrImage': widget.currentUser.usrImage,
    });

    // usrLst.forEach((usrLstElement) {
    //   //_chtGroup.add(usrLstElement['usrId']);
    //   print(usrLstElement.keys['sss'].toString());
    // });

    // print(_chtGroup);
    // print(_chtGroupUsers);

    var newCahtGroupData = {
      'chtGroup': _chtGroup,
      'chtGroupUsers': _chtGroupUsers,
      'chtGroupType': _chtGroupType,
      'chtId': _chtId,
      'chtImage': _chtImage,
      'chtLastTime': _chtLastTime,
      'chtName': _chtName,
      'chtOwner': _chtOwner,
    };
    await instantChattingRef.doc(_chtId).set(newCahtGroupData).whenComplete(() {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChattingPage(
            chtId: _chtId,
            chtGroup: _chtGroup,
            chtGroupUsers: _chtGroupUsers,
            chtName: _chtName,
            chtOwner: _chtOwner,
            chtGroupType: _chtGroupType,
            chtImage: _chtImage,
            currentUser: widget.currentUser,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text('إنشاء مجموعات الدردشة'),
      ),
      body: Builder(
        builder: (contextx) => SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidate,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: <Widget>[
                  MasterLabel(
                    theColor: masterBlue,
                    content: Column(
                      children: [
                        Text(
                          'إنشاء مجموعة دردشة جماعية',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.all(1.0),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: (_width / 3),
                              child: MasterLabel(
                                theColor: darkGreen,
                                content: Text(
                                  'شعار المجموعة',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Center(
                                child: CircleAvatar(
                                  radius: 45.0,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: (chtImageController == null)
                                      ? AssetImage(
                                          'assets/images/Group-icon.png')
                                      : FileImage(chtImageController),
                                  child: IconButton(
                                    icon: (chtImageController == null)
                                        ? Icon(Icons.add)
                                        : Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      //print('Logo Add');
                                      if (chtImageController == null) {
                                        handleChooseGallery();
                                      } else {
                                        setState(() {
                                          chtImageController = null;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: (_width / 3) * 2,
                          child: Column(
                            children: [
                              MasterLabel(
                                theColor: darkGreen,
                                content: Text(
                                  'اسم المجموعة',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                                child: TextFormField(
                                  autocorrect: false,
                                  controller: chtNameController,
                                  decoration: InputDecoration(
                                    hintText: 'اسم المجموعة',
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'الحقل مطلوب / Required Field';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                                  child: RaisedButton(
                                    textColor: Colors.white,
                                    child: Text(
                                      'إنشاء الحساب',
                                    ),
                                    color: masterBlue,
                                    onPressed: () {
                                      if (_formKey.currentState.validate() &&
                                          usrLst.length > 0) {
                                        _formKey.currentState.save();
                                        handleCreateChatGroup();
                                      } else {
                                        Scaffold.of(contextx).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'نرجو التأكد من المعلومات المسجلة واختيار أعضاء للمجموعة',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                        setState(() {
                                          _autoValidate =
                                              AutovalidateMode.always;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  ),
                  MasterLabel(
                    theColor: darkGreen,
                    content: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'أعضاء المجموعة',
                              style: TextStyle(color: Colors.white),
                            ),
                            Container(
                              width: 50.0,
                              height: 30.0,
                              padding: EdgeInsets.all(5.0),
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
                                _groupNumber.toString(),
                                style: TextStyle(
                                  color: bgGray,
                                  fontFamily: englishFont,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  getContactsList(searchText: _searchText),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
