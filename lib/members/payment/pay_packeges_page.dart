import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/members/profile/page_profile_edit.dart';
import 'package:mbo/wedgits/cashImages.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';

import '../../main.dart';
import 'pay_ahome_page.dart';
import 'pay_credit_page.dart';

class PaymentPackegesPage extends StatefulWidget {
  final MyUser currentUser;
  final VoidCallback doSignOut;
  final VoidCallback getSignInStatus;

  PaymentPackegesPage(
      {this.currentUser, this.getSignInStatus, this.doSignOut, Key key})
      : super(key: key);

  @override
  _PaymentPackegesPageState createState() => _PaymentPackegesPageState();
}

class _PaymentPackegesPageState extends State<PaymentPackegesPage> {
  String _projectVersion = '';

  @override
  void initState() {
    super.initState();
    getAppInformation();
  }

  getAppInformation() async {
    try {
      _projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      _projectVersion = '0.0.0';
    }
    setState(() {
      _projectVersion = _projectVersion;
    });
  }

  getSubscriptions() {
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
                        : 'غير متوفر',
                    style: TextStyle(
                      fontFamily: englishFont,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentCreditPage(
                          currentUser: widget.currentUser,
                          doSignOut: widget.doSignOut,
                          getSignInStatus: widget.getSignInStatus,
                          packgeRecord: doc.data(),
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
                    child: Icon(Icons.payment_outlined),
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

  // setAdminAccept() {
  //   usersRef.doc(widget.currentUser.usrId).update({
  //     'usrStatus': 1,
  //   }).then((onValue) async {
  //     widget.getSignInStatus();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مجموعة المنارة المتكاملة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: double.infinity,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(1.0),
                ),
                MasterLabel(
                  theColor: darkGreen,
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'الإشتراك والدفع الإلكتروني',
                        style: TextStyle(fontSize: 22.0, color: Colors.white),
                      ),
                      Text(
                        'اختر باقة الإشتراك',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                ),
                getSubscriptions(),
                // CircleAvatar(
                //   backgroundColor: Colors.white,
                //   radius: 45.0,
                //   backgroundImage: AssetImage('assets/images/logo.png'),
                //   child: myCachedNetworkImage(
                //     widget.currentUser.usrImage,
                //     myBorderRadius: 50.0,
                //   ),
                // ),
                // FlatButton(
                //   color: Colors.green,
                //   onPressed: () {
                //     setAdminAccept();
                //   },
                //   child: Text(
                //     'الدفع الإلكتروني',
                //     style: TextStyle(
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      drawer: (widget.currentUser.usrStatus == 0)
          ? Drawer(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    otherAccountsPictures: [
                      IconButton(
                        icon: Icon(
                          Icons.adjust,
                          color: Colors.white,
                        ),
                        onPressed: () => widget.doSignOut(),
                      ),
                    ],
                    accountName: Text(
                        (widget.currentUser.usrSalutationAr != null)
                            ? widget.currentUser.usrSalutationAr + ' / '
                            : widget.currentUser.usrName),
                    accountEmail: Text(
                      widget.currentUser.usrEmail,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    currentAccountPicture: CircleAvatar(
                      //radius: 45.0,
                      backgroundColor: Colors.blue,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                      child: myCachedNetworkImage(
                        widget.currentUser.usrImage,
                        myBorderRadius: 50.0,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.add_alert),
                    title: Text('التنبيهات'),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEditPage(
                            currentUser: widget.currentUser,
                            getSignInStatus: widget.getSignInStatus,
                          ),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.perm_identity,
                    ),
                    title: Text('الملف الشخصي'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.attach_money,
                    ),
                    title: Text('معلومات الإشتراك'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentHomePage(
                            currentUser: widget.currentUser,
                            getSignInStatus: widget.getSignInStatus,
                            doSignOut: widget.doSignOut,
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    onTap: () => widget.doSignOut(),
                    leading: Icon(
                      Icons.exit_to_app,
                    ),
                    title: Text('تسجيل الخروج'),
                  ),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: ListTile(
                        onTap: () {},
                        title: Text(
                          'نسخة التطبيق ' + _projectVersion,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
