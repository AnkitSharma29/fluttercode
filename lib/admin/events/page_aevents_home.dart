import 'package:flutter/material.dart';
import 'package:mbo/classes/date_formatter.dart';
import 'package:mbo/wedgits/settings.dart';

import '../../main.dart';
import 'page_events_add.dart';
import 'page_events_edit.dart';

class EventsHomePage extends StatefulWidget {
  EventsHomePage({Key key}) : super(key: key);

  @override
  _EventsHomePageState createState() => _EventsHomePageState();
}

class _EventsHomePageState extends State<EventsHomePage> {
  changeEventStatus(bool evntStatus, String evntId) async {
    String msgText = (evntStatus == true)
        ? 'سيتم إلغاء المناسبة'
        : 'سيتم إعادة تفعيل المناسبة';
    bool returnVal = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here

          title: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('تنبيه'),
          ),
          content: Text(
            msgText,
            textDirection: TextDirection.rtl,
          ),
          actions: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: FlatButton(
                child: Text("تراجع"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: FlatButton(
                color: masterBlue,
                child: Text("نعم"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ),
          ],
        );
      },
    );
    if (returnVal == true) {
      eventsRef.doc(evntId).update({
        'evntStatus': !evntStatus,
      });
    }
  }

  getlistCities() {
    return StreamBuilder(
      stream: eventsRef.orderBy('evntStartDate', descending: true).snapshots(),
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
            Color clr = bgGray;
            bool evntStatus = doc.data()['evntStatus'];
            // int dateComparing =
            //     (doc.data()['evntEndDate'].toDate()).compareTo(DateTime.now());

            DateTime dateEvent = doc.data()['evntEndDate'].toDate();
            DateTime dateNow = DateTime.now();
            int dateComparing = dateNow.difference(dateEvent).inDays;

            if ((dateComparing == 0)) {
              clr = masterBlue;
            } else if (dateComparing > 0) {
              clr = lightGreen;
            } else if (dateComparing < 0) {
              clr = darkGreen;
            }
            print(dateComparing);

            lst.add(
              Card(
                color: (evntStatus == false) ? bgGray : clr,
                child: ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        (doc.data()['evntName'] != null)
                            ? doc.data()['evntName']
                            : 'غير متوفر',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Divider(),
                      Text(
                        (doc.data()['evntStartDate'] != null)
                            ? timestampTodate(doc.data()['evntStartDate'])
                            : 'Not Available',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: englishFont,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventsEditPage(
                          recordDate: doc.data(),
                          //currentUser: widget.currentUser,
                          //relUsrId: doc.data['usrId'],
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    changeEventStatus(doc.data()['evntStatus'], doc.id);
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
        title: Text('تقويم المناسبات'),
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
                  builder: (context) => EventsAddPage(),
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
            child: getlistCities(),

            //Column(
            //children: [
            // GestureDetector(
            //   child: Container(
            //     padding: EdgeInsets.only(
            //       bottom: 10.0,
            //     ),
            //     child: MasterLabel(
            //       theColor: darkGreen,
            //       content: Text(
            //         'إدارة المدن',
            //         style: TextStyle(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => CitiesShowPage(),
            //       ),
            //     );
            //   },
            // ),
            // GestureDetector(
            //   child: Container(
            //     padding: EdgeInsets.only(
            //       bottom: 10.0,
            //     ),
            //     child: MasterLabel(
            //       theColor: darkGreen,
            //       content: Text(
            //         'إدارة الجنسيات',
            //         style: TextStyle(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => CountriesShowPage(),
            //       ),
            //     );
            //   },
            // ),
            // GestureDetector(
            //   child: Container(
            //     padding: EdgeInsets.only(
            //       bottom: 10.0,
            //     ),
            //     child: MasterLabel(
            //       theColor: darkGreen,
            //       content: Text(
            //         'إدارة الحالة الإجتماعية',
            //         style: TextStyle(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => MaritalStatusShowPage(),
            //       ),
            //     );
            //   },
            // ),
            // GestureDetector(
            //   child: Container(
            //     padding: EdgeInsets.only(
            //       bottom: 10.0,
            //     ),
            //     child: MasterLabel(
            //       theColor: darkGreen,
            //       content: Text(
            //         'إدارة الألقاب',
            //         style: TextStyle(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => SalutationShowPage(),
            //       ),
            //     );
            //   },
            // ),
            // GestureDetector(
            //   child: Container(
            //     padding: EdgeInsets.only(
            //       bottom: 10.0,
            //     ),
            //     child: MasterLabel(
            //       theColor: darkGreen,
            //       content: Text(
            //         'إدارة النشاطات التجارية',
            //         style: TextStyle(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => SectorsShowPage(),
            //       ),
            //     );
            //   },
            // ),
            // GestureDetector(
            //   child: Container(
            //     padding: EdgeInsets.only(
            //       bottom: 10.0,
            //     ),
            //     child: MasterLabel(
            //       theColor: darkGreen,
            //       content: Text(
            //         'إدارة مدد الإشتراكات',
            //         style: TextStyle(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            //   onTap: () {
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(
            //     //     builder: (context) => SubscriptionsShowPage(),
            //     //   ),
            //     // );
            //   },
            // ),
            //],
            //),
          ),
        ),
      ),
    );
  }
}
