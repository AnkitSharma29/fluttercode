import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/main.dart';
import 'package:mbo/members/chatting/page_chat_chatting.dart';
import 'package:mbo/wedgits/cashImages.dart';
import 'package:mbo/wedgits/settings.dart';

class ChatAddIndividualPage extends StatefulWidget {
  final MyUser currentUser;
  ChatAddIndividualPage({this.currentUser, Key key}) : super(key: key);

  @override
  _ChatAddIndividualPageState createState() => _ChatAddIndividualPageState();
}

class _ChatAddIndividualPageState extends State<ChatAddIndividualPage> {
  String _searchText;
  bool _isSearchButton = true;
  final searchTextController = TextEditingController();

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
            //   String usrSalutation = (doc.data()['usrSalutationAr'] != null)
            //       ? doc.data()['usrSalutationAr'] + ' / '
            //       : './';
            String usrName = (doc.data()['usrName'] != null)
                ? doc.data()['usrName']
                : 'غير معروف';
            lst.add(
              Card(
                color: lightGreen,
                child: ListTile(
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
                  onTap: () => checkIsOnChat(doc),
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

  checkIsOnChat(DocumentSnapshot targetUser) async {
    //print(targetUser.data());
    bool _isFound = false;
    var _theChatGroubData;
    String _targetUserId = targetUser.data()['usrId'];
    String _targetUserName = targetUser.data()['usrName'];
    String _targetUserImage = targetUser.data()['usrImage'];

    String _currentUserId = widget.currentUser.usrId;
    String _currentUserName = widget.currentUser.usrName;
    String _currentUserImage = widget.currentUser.usrImage;
    //print('targetUser ==' + _targetUserId);
    //print('currentUser ==' + _currentUserId);

    await instantChattingRef
        .where('chtGroupType', isEqualTo: 0)
        .where(
          'chtGroup',
          arrayContains: _targetUserId,
        )
        .get()
        .then((documents) {
      //print('Documnets Count IS == ' + documents.docs.length.toString());
      if (documents.docs.length > 0) {
        //print(documents.docs.first.data().toString());
        documents.docs.forEach((docData) {
          List _chtGroup = docData.data()['chtGroup'];
          //print(_chtGroup);
          if (_chtGroup.contains(_currentUserId)) {
            _isFound = true;
            _theChatGroubData = docData.data();
            return;
          }
        });
      }
    });

    //print('_isFound == ' + _isFound.toString());
    if (_isFound == true) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChattingPage(
            chtId: _theChatGroubData['chtId'],
            chtGroup: _theChatGroubData['chtGroup'],
            chtGroupUsers: _theChatGroubData['chtGroupUsers'],
            chtName: _targetUserName,
            chtOwner: _theChatGroubData['chtOwner'],
            chtGroupType: _theChatGroubData['chtGroupType'],
            chtImage: _theChatGroubData['chtImage'],
            currentUser: widget.currentUser,
          ),
        ),
      );
    } else {
      DocumentReference ref = instantChattingRef.doc();
      String _chtId = ref.id;
      var _chtGroup = [_targetUserId, _currentUserId];
      var _chtGroupUsers = [
        {
          'usrId': _currentUserId,
          'usrName': _currentUserName,
          'usrImage': _currentUserImage,
        },
        {
          'usrId': _targetUserId,
          'usrName': _targetUserName,
          'usrImage': _targetUserImage,
        },
      ];
      var newCahtIndividual = {
        'chtGroup': _chtGroup,
        'chtGroupType': 0,
        'chtGroupUsers': _chtGroupUsers,
        'chtId': _chtId,
        'chtImage': null,
        'chtLastTime': Timestamp.now(),
        'chtName': null,
        'chtOwner': null,
      };
      await instantChattingRef
          .doc(_chtId)
          .set(newCahtIndividual)
          .whenComplete(() {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChattingPage(
              chtId: _chtId,
              chtGroup: _chtGroup,
              chtGroupUsers: _chtGroupUsers,
              chtName: _targetUserName,
              chtOwner: null,
              chtGroupType: 0,
              chtImage: _targetUserImage,
              currentUser: widget.currentUser,
            ),
          ),
        );
      });
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: TextFormField(
          controller: searchTextController,
          onChanged: (value) {
            if (value.trim().isNotEmpty) {
              _isSearchButton = false;

              if (value.trim().length >= 3) {
                setState(() {
                  _searchText = value.trim();
                });
              } else {
                setState(() {
                  _searchText = null;
                });
              }
            } else {
              _isSearchButton = true;
            }

            setState(() {
              _isSearchButton = _isSearchButton;
            });
          },
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: new TextStyle(
            color: masterBlue,
          ),
          decoration: new InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "بحث عن الأعضاء",
            hintStyle: new TextStyle(
              color: bgGray,
            ),
          ),
        ),
        actions: <Widget>[
          (_isSearchButton)
              ? new IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () {},
                )
              : new IconButton(
                  icon: Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    searchTextController.clear();
                    setState(() {
                      _isSearchButton = true;
                    });
                  },
                )
        ],
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.all(
              15.0,
            ),
            child: getContactsList(searchText: _searchText),
          ),
        ),
      ),
    );
  }
}
