import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/classes/date_formatter.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';

import 'pay_packeges_page.dart';

class PaymentHomePage extends StatefulWidget {
  final MyUser currentUser;
  final VoidCallback getSignInStatus;
  final VoidCallback doSignOut;

  PaymentHomePage(
      {this.currentUser, this.getSignInStatus, this.doSignOut, Key key})
      : super(key: key);

  @override
  _PaymentHomePageState createState() => _PaymentHomePageState();
}

class _PaymentHomePageState extends State<PaymentHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _autoValidate = AutovalidateMode.disabled;

  //String _errorMasseges;

  File usrImgFile;
  String usrImgController;

  String usrSalutationController;
  List<DropdownMenuItem<String>> salutation = [];
  Map mapSalutation = {};

  final usrNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadFormUserInformation();
  }

  loadFormUserInformation() {
    usrImgController = widget.currentUser.usrImage;
    usrNameController.text = widget.currentUser.usrName;
    setState(() {
      usrSalutationController = widget.currentUser.usrSalutationId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text('الملف الشخصي'),
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
                  Padding(
                    padding: EdgeInsets.all(1.0),
                  ),
                  MasterLabel(
                    theColor: darkGreen,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'معلومات الإشتراك الحالية',
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MasterLabel(
                            content: Text('تاريخ التسجيل'),
                            theColor: bgGray,
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              10.0,
                            ),
                            child: Text(
                              timestampTodate(widget.currentUser.usrDateTime),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          MasterLabel(
                            content: Text('تاريخ بداية الإشتراك'),
                            theColor: bgGray,
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              10.0,
                            ),
                            child: Text(
                              (widget.currentUser.payDateStart != null)
                                  ? timestampTodate(
                                      widget.currentUser.payDateStart)
                                  : 'غير محدد',
                              textAlign: TextAlign.right,
                            ),
                          ),
                          MasterLabel(
                            content: Text('تاريخ نهاية الإشتراك'),
                            theColor: bgGray,
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              10.0,
                            ),
                            child: Text(
                              (widget.currentUser.payDateEnd != null)
                                  ? timestampTodate(
                                      widget.currentUser.payDateEnd)
                                  : 'غير محدد',
                              textAlign: TextAlign.right,
                            ),
                          ),
                          MasterLabel(
                            content: Text('عدد الأيام المتبقية'),
                            theColor: bgGray,
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              10.0,
                            ),
                            child: Text(
                              (widget.currentUser.payDateEnd != null &&
                                      widget.currentUser.payDateStart != null)
                                  ? getDaysDifference(
                                        widget.currentUser.payDateEnd.toDate(),
                                        widget.currentUser.payDateStart
                                            .toDate(),
                                      ) +
                                      ' يوم '
                                  : 'غير محدد',
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        child: Text(
                          'تجديد الإشتراك',
                        ),
                        color: masterBlue,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPackegesPage(
                                currentUser: widget.currentUser,
                                doSignOut: widget.doSignOut,
                                getSignInStatus: widget.getSignInStatus,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
