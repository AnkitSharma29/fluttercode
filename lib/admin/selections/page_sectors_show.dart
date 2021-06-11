import 'package:flutter/material.dart';
import 'package:mbo/main.dart';
import 'package:mbo/wedgits/settings.dart';

import 'page_sectors_add.dart';

class SectorsShowPage extends StatefulWidget {
  SectorsShowPage({Key key}) : super(key: key);

  @override
  _SectorsShowPageState createState() => _SectorsShowPageState();
}

class _SectorsShowPageState extends State<SectorsShowPage> {
  getlistSectors() {
    return StreamBuilder(
      stream: lookUpSectorRef.orderBy('secAr', descending: true).snapshots(),
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
                        (doc.data()['secAr'] != null)
                            ? doc.data()['secAr']
                            : 'غير متوفر',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Divider(),
                      Text(
                        (doc.data()['secEn'] != null)
                            ? doc.data()['secEn']
                            : 'Not Available',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: englishFont,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    ],
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
        title: Text('إدارة التصنيف التجاري'),
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
                  builder: (context) => SectorsAddPage(),
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
            child: getlistSectors(),
          ),
        ),
      ),
    );
  }
}
