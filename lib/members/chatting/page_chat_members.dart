import 'package:flutter/material.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/main.dart';
import 'package:mbo/wedgits/cashImages.dart';
import 'package:mbo/wedgits/settings.dart';

class ChatMembersPage extends StatefulWidget {
  final MyUser currentUser;
  final String chtId;
  final List chtGroup;
  final List chtGroupUsers;
  final String chtName;
  final String chtOwner;
  final String chtImage;
  final int chtGroupType;

  ChatMembersPage(
      {this.chtId,
      this.currentUser,
      this.chtGroup,
      this.chtGroupUsers,
      this.chtName,
      this.chtOwner,
      this.chtImage,
      this.chtGroupType,
      Key key})
      : super(key: key);

  @override
  _ChatMembersPageState createState() => _ChatMembersPageState();
}

class _ChatMembersPageState extends State<ChatMembersPage> {
  bool isLoading = false;
  String chtImage;
  String photoUrl = '';

  void _showExitFromGroubDialog(targetUser) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "سيتم إستبعاد " + targetUser['usrName'] + " من مجموعة",
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          content: new Text(
            widget.chtName,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.green,
              child: new Text("نعم"),
              onPressed: () {
                exitFromGroub(targetUser);
              },
            ),
            new FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.grey,
              child: new Text("تراجع"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "هل أنت متأكد من الحذف ؟",
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          content: new Text(
            widget.chtName,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.green,
              child: new Text("نعم"),
              onPressed: () {
                deleteGroub();
              },
            ),
            new FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.grey,
              child: new Text("تراجع"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deleteGroub() async {
    Navigator.of(context).pop();
    await instantChattingRef.doc(widget.chtId).update({
      'chtGroupType': -1,
    });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  exitFromGroub(targetUser) async {
    Navigator.of(context).pop();
    await instantChattingRef.doc(widget.chtId).get().then((doc) async {
      if (doc.exists) {
        List chtGroupUsersLst = doc.data()['chtGroupUsers'];
        List chtGroupLst = doc.data()['chtGroup'];
        chtGroupLst.remove(targetUser['usrId']);
        chtGroupUsersLst.removeWhere((chtGroupUsersLst) =>
            chtGroupUsersLst['usrId'] == targetUser['usrId']);
        // print(chtGroupUsersLst);
        // print('******************');
        // print(chtGroupLst);
        await instantChattingRef.doc(widget.chtId).update({
          'chtGroup': chtGroupLst,
          'chtGroupUsers': chtGroupUsersLst,
        });
      }
    });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Widget getTheUsers() {
    var usrLst = [];

    //print(widget.chtGroupUsers);
    // widget.chtGroup
    //     .forEach((v) => list.add({v['usrId'], v['usrImage'], v['usrName']}));

    for (var usrLstElement in widget.chtGroupUsers) {
      //print(usrLstElement['usrId']);
      //print(usrLstElement['usrName']);
      //print(usrLstElement['usrImage']);

      usrLst.add({
        'usrId': usrLstElement['usrId'],
        'usrName': usrLstElement['usrName'],
        'usrImage': usrLstElement['usrImage'],
      });
    }

    //print(usrLst);

    //print(usrLst[0]['usrName']);
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: widget.chtGroup.length,
        itemBuilder: (context, index) {
          return buildItem(index, usrLst[index]);
          //return Text('${usrLst[index]['usrName']}');
        },
      ),
    );
  }

  Widget buildItem(int index, doc) {
    return Card(
      color: lightGreen,
      child: ListTile(
        title: Text(doc['usrName']),
        leading: SizedBox(
          width: 40.0,
          height: 40.0,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 45.0,
            backgroundImage: AssetImage('assets/images/logo.png'),
            child: myCachedNetworkImage(
              doc['usrImage'],
              myBorderRadius: 50.0,
            ),
          ),
        ),
        trailing: (widget.chtGroupType == 1 &&
                widget.chtOwner == widget.currentUser.usrId &&
                doc['usrId'] != widget.currentUser.usrId)
            ? IconButton(
                icon: Icon(
                  Icons.album,
                  color: Colors.red,
                ),
                onPressed: () {
                  _showExitFromGroubDialog(doc);
                },
              )
            : (widget.chtGroupType == 1 &&
                    widget.chtOwner != widget.currentUser.usrId &&
                    doc['usrId'] == widget.currentUser.usrId)
                ? IconButton(
                    icon: Icon(
                      Icons.album,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _showExitFromGroubDialog(doc);
                    },
                  )
                : Container(
                    width: 10.0,
                    height: 10.0,
                  ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل المجموعة'),
        centerTitle: true,
        actions: <Widget>[
          (widget.chtOwner == widget.currentUser.usrId &&
                  widget.chtGroupType == 1)
              ? IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.yellow,
                  ),
                  onPressed: () {
                    _showDialog();
                  },
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
        ],
      ),
      body: (isLoading)
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            SizedBox(
                              width: 100.0,
                              height: 100.0,
                              child: (widget.chtImage != null)
                                  ? myCachedNetworkImage(
                                      widget.chtImage,
                                      myBorderRadius: 50.0,
                                    )
                                  : Image.asset('assets/images/Group-icon.png'),
                            ),
                          ],
                        ),
                      ),
                      width: double.infinity,
                      margin: EdgeInsets.all(20.0),
                    ),
                    Container(
                      child: Text(
                        widget.chtName,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                    getTheUsers(),
                  ],
                ),
              ),
            ),
    );
  }
}
