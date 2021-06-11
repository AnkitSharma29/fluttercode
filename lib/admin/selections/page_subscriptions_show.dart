import 'package:flutter/material.dart';
import 'package:mbo/main.dart';
import 'package:mbo/wedgits/settings.dart';

import 'page_subscriptions_add.dart';

class SubscriptionsShowPage extends StatefulWidget {
  SubscriptionsShowPage({Key key}) : super(key: key);

  @override
  _SubscriptionsShowPageState createState() => _SubscriptionsShowPageState();
}

class _SubscriptionsShowPageState extends State<SubscriptionsShowPage> {
  getlistSalutation() {
    return StreamBuilder(
      stream: lookUpSubscriptionsRef
          .orderBy('subDays', descending: true)
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
        List<Widget> lst = [];
        snapshot.data.documents.forEach(
          (doc) {
            lst.add(
              Card(
                child: ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        (doc.data()['subAr'] != null)
                            ? doc.data()['subAr']
                            : 'غير متوفر',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Divider(),
                      Text(
                        (doc.data()['subEn'] != null)
                            ? doc.data()['subEn']
                            : 'Not Available',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: englishFont,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                      Divider(),
                      Text(
                        (doc.data()['subAmount'] != null)
                            ? doc.data()['subAmount'].toString() +
                                ' ريال سعودي '
                            : '0',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: englishFont,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    (doc.data()['subDays'] != null)
                        ? doc.data()['subDays'].toString() + ' يوم '
                        : 'Not Available',
                    style: TextStyle(
                      fontFamily: englishFont,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MemberRelativsUpdatePage(
                    //       currentUser: widget.currentUser,
                    //       relUsrId: doc.data['usrId'],
                    //     ),
                    //   ),
                    // );
                  },
                  trailing: Container(
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
                    child: Icon(Icons.edit),
                  ),
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
        title: Text('إدارة مدد الإشتراكات'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriptionsAddPage(),
                ),
              );
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
            child: getlistSalutation(),
          ),
        ),
      ),
    );
  }
}
