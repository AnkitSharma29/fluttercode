import 'package:flutter/material.dart';
import 'package:mbo/classes/date_formatter.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';

class MembersEventsShowPage extends StatefulWidget {
  final recordDate;
  MembersEventsShowPage({this.recordDate, Key key}) : super(key: key);

  @override
  _MembersEventsShowPageState createState() => _MembersEventsShowPageState();
}

class _MembersEventsShowPageState extends State<MembersEventsShowPage> {
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
            child: Column(
              children: [
                MasterLabel(
                  content: Text(
                    widget.recordDate['evntName'],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  theColor: masterBlue,
                ),
                Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(
                            10.0,
                          ),
                          child: Text(
                            widget.recordDate['evntDescription'],
                            textAlign: TextAlign.right,
                          ),
                        ),
                        (widget.recordDate['evntExtraInfo'] != null)
                            ? MasterLabel(
                                content: Text('معلومات إضافية'),
                                theColor: bgGray,
                              )
                            : Container(
                                width: 0.0,
                                height: 0.0,
                              ),
                        (widget.recordDate['evntExtraInfo'] != null)
                            ? Padding(
                                padding: EdgeInsets.all(
                                  10.0,
                                ),
                                child: Text(
                                  widget.recordDate['evntExtraInfo'],
                                  textAlign: TextAlign.right,
                                ),
                              )
                            : Container(
                                width: 0.0,
                                height: 0.0,
                              ),
                        MasterLabel(
                          content: Text('تاريخ'),
                          theColor: bgGray,
                        ),
                        Padding(
                            padding: EdgeInsets.all(
                              10.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  timestampTodate(
                                      widget.recordDate['evntStartDate']),
                                  textAlign: TextAlign.right,
                                ),
                                Text(
                                  'عدد الأيام المتبقية : ' +
                                      getDaysDifference(
                                          widget.recordDate['evntStartDate']
                                              .toDate(),
                                          DateTime.now()),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            )),
                        MasterLabel(
                          content: Text('الوقت'),
                          theColor: bgGray,
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                            10.0,
                          ),
                          child: Text(
                            'يبدأ : ' +
                                timestampTotime(
                                    widget.recordDate['evntStartTime']),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                            10.0,
                          ),
                          child: Text(
                            'ينتهى : ' +
                                timestampTotime(
                                    widget.recordDate['evntEndTime']),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        MasterLabel(
                          content: Text('العنوان'),
                          theColor: bgGray,
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                            10.0,
                          ),
                          child: Text(
                            widget.recordDate['evntCityNameAr'],
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                            10.0,
                          ),
                          child: Text(
                            widget.recordDate['evntAddress'],
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                            10.0,
                          ),
                          child: MasterLabel(
                              content: Text(
                                (widget.recordDate['evntStatus'] == true)
                                    ? 'قائم في نفس الموعد'
                                    : 'تم الإلغاء المناسبة',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              theColor:
                                  (widget.recordDate['evntStatus'] == true)
                                      ? darkGreen
                                      : bgGray),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
