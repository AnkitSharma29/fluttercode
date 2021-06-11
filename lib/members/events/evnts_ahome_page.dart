import 'package:flutter/material.dart';
import 'package:mbo/classes/date_formatter.dart';
import 'package:mbo/wedgits/settings.dart';

import '../../main.dart';
import 'evnts_show_page.dart';

class MembersEventsHomePage extends StatefulWidget {
  MembersEventsHomePage({Key key}) : super(key: key);

  @override
  _MembersEventsHomePageState createState() => _MembersEventsHomePageState();
}

class _MembersEventsHomePageState extends State<MembersEventsHomePage> {
  getlistEvents() {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return StreamBuilder(
      stream: eventsRef
          .orderBy('evntStartDate', descending: false)
          .where('evntStartDate', isGreaterThanOrEqualTo: today)
          .where('evntStatus', isEqualTo: true)
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
                        (doc.data()['evntCityNameAr'] != null)
                            ? doc.data()['evntCityNameAr']
                            : 'غير معروف',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: arabicFont,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
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
                        builder: (context) => MembersEventsShowPage(
                          recordDate: doc.data(),
                        ),
                      ),
                    );
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
                    child: Icon(
                      Icons.remove_red_eye_outlined,
                      color: bgGray,
                    ),
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
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.all(
              15.0,
            ),
            child: getlistEvents(),

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
