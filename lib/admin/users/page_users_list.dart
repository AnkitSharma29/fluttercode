import 'package:flutter/material.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/classes/User_Classification.dart';
import 'package:mbo/classes/date_formatter.dart';
import 'package:mbo/wedgits/cashImages.dart';
import 'package:mbo/wedgits/settings.dart';

import '../../main.dart';
import 'page_users_information.dart';

class UsersListPage extends StatefulWidget {
  final int usrType;
  final int usrStatus;
  final String title;
  UsersListPage({this.title, this.usrStatus, this.usrType, Key key})
      : super(key: key);

  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  @override
  void initState() {
    super.initState();
  }

  getListUsersNew() {
    var query;
    if (widget.usrStatus == 10 && widget.usrType == 10) {
      query = usersRef.where('usrType',
          whereIn: [-2, -1, 0, 1]).orderBy('usrDateTime', descending: true);
    }
    if (widget.usrType == 0 && query == null) {
      query = usersRef
          .orderBy('usrDateTime', descending: true)
          .where('usrType', isEqualTo: widget.usrType);
    }
    if (query == null) {
      query = usersRef
          .orderBy('usrDateTime', descending: true)
          .where('usrType', isEqualTo: widget.usrType)
          .where('usrStatus', isEqualTo: widget.usrStatus);
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
        Map usrClass;
        Color currentBackColor;
        Color currentForeColor;

        snapshot.data.documents.forEach(
          (doc) {
            usrClass = getUserClassification(
                doc.data()['usrType'], doc.data()['usrStatus']);
            currentBackColor = usrClass['currentBackColor'];
            currentForeColor = usrClass['currentForeColor'];

            String usrSalutation = (doc.data()['usrSalutationAr'] != null)
                ? doc.data()['usrSalutationAr'] + ' / '
                : './';
            String usrName = (doc.data()['usrName'] != null)
                ? doc.data()['usrName']
                : 'غير معروف';

            lst.add(
              Card(
                color: currentBackColor,
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
                        usrSalutation + usrName,
                        style: TextStyle(
                          color: currentForeColor,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        (doc.data()['usrEmail'] != null)
                            ? doc.data()['usrEmail']
                            : 'Not Avalable',
                        style: TextStyle(
                          color: currentForeColor,
                          fontFamily: englishFont,
                          fontSize: 12.0,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    (doc.data()['usrDateTime'] != null)
                        ? timestampTodate(doc.data()['usrDateTime'])
                        : 'غر معروف',
                    style: TextStyle(
                      fontFamily: englishFont,
                      color: currentForeColor,
                      fontSize: 12.0,
                    ),
                  ),
                  trailing: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: currentForeColor,
                        style: BorderStyle.solid,
                        width: 1.0,
                      ),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Icon(
                      Icons.remove_red_eye_outlined,
                      color: currentForeColor,
                      size: 18.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersInformationPage(
                          theUser: MyUser.fromDocument(doc),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
        return Column(
          children: lst,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.all(
              15.0,
            ),
            child: getListUsersNew(),
          ),
        ),
      ),
    );
  }
}
