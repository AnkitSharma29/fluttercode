import 'package:flutter/material.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/wedgits/cashImages.dart';
import '../../main.dart';
import 'info_ext_add.dart';
import 'info_ext_show.dart';
import 'info_job_add.dart';
import 'package:mbo/wedgits/settings.dart';

import 'info_job_show.dart';
import 'info_personal_add.dart';
import 'info_personal_show.dart';

class InformationHomePage extends StatefulWidget {
  final MyUser currentUser;
  final VoidCallback doSignOut;
  final VoidCallback getSignInStatus;

  InformationHomePage(
      {this.currentUser, this.getSignInStatus, this.doSignOut, Key key})
      : super(key: key);

  @override
  _InformationHomePageState createState() => _InformationHomePageState();
}

class _InformationHomePageState extends State<InformationHomePage> {
  Widget getStatusIcons(allStatus) {
    if (allStatus == null) {
      return Icon(
        Icons.add,
        color: Colors.white,
        size: 30.0,
      );
    }
    return Row(
      children: [
        Icon(
          Icons.edit,
          color: Colors.white,
          size: 30.0,
        ),
        Icon(
          Icons.check,
          color: Colors.white,
          size: 30.0,
        ),
      ],
    );
  }

  var prsStatus;
  var jobStatus;
  var extStatus;

  getRefresedData() async {
    setState(() {
      prsStatus = widget.currentUser.prsStatus;
      jobStatus = widget.currentUser.jobStatus;
      extStatus = widget.currentUser.extStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    getRefresedData();
  }

  setAdminAccept() {
    usersRef.doc(widget.currentUser.usrId).update({
      'usrStatus': 0,
    }).then((onValue) async {
      widget.getSignInStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    getRefresedData();
    return Scaffold(
      appBar: AppBar(
        title: Text('مجموعة المنارة المتكاملة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Text(widget.currentUser.prsStatus.toString()),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Center(
                  child: CircleAvatar(
                    radius: 65.0,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  //color: darkGreen,
                  color: masterBlue,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'الخطوة الأولى' + ' : ' + ' إنشاء حساب ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'First Step : Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: englishFont,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 30.0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  switch (prsStatus) {
                    case true:
                    case false:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationPersonalShowPage(
                            currentUser: widget.currentUser,
                            getSignInStatus: widget.getSignInStatus,
                          ),
                        ),
                      );
                      break;
                    default:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationPersonalAddPage(
                            currentUser: widget.currentUser,
                            getSignInStatus: widget.getSignInStatus,
                          ),
                        ),
                      );
                  }
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: (widget.currentUser.prsStatus == null)
                        ? darkGreen
                        : (widget.currentUser.prsStatus == true)
                            ? masterBlue
                            : Colors.orange[900],
                    //color: masterBlue,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'الخطوة الثانية' + ' : ' + 'المعلومات الشخصية ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Second Step : Personal Information',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: englishFont,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          getStatusIcons(prsStatus),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  switch (jobStatus) {
                    case true:
                    case false:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationJobShowPage(
                            currentUser: widget.currentUser,
                            getSignInStatus: widget.getSignInStatus,
                          ),
                        ),
                      );
                      break;
                    default:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationJobAddPage(
                            currentUser: widget.currentUser,
                            getSignInStatus: widget.getSignInStatus,
                          ),
                        ),
                      );
                  }
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: (widget.currentUser.jobStatus == null)
                        ? darkGreen
                        : (widget.currentUser.jobStatus == true)
                            ? masterBlue
                            : Colors.orange[900],
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'الخطوة الثالثة' + ' : ' + 'معلومات عن العمل ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Third Step : Information about work',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: englishFont,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          getStatusIcons(jobStatus),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  switch (extStatus) {
                    case true:
                    case false:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationExtShowPage(
                            currentUser: widget.currentUser,
                            getSignInStatus: widget.getSignInStatus,
                          ),
                        ),
                      );
                      break;
                    default:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationExtAddPage(
                            currentUser: widget.currentUser,
                            getSignInStatus: widget.getSignInStatus,
                          ),
                        ),
                      );
                  }
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: (widget.currentUser.extStatus == null)
                        ? darkGreen
                        : (widget.currentUser.extStatus == true)
                            ? masterBlue
                            : Colors.orange[900],
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'الخطوة الرابعة' + ' : ' + 'تفاصيل إضافية ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Fourth Step : Additional details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: englishFont,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          getStatusIcons(extStatus),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  if (prsStatus != null &&
                      jobStatus != null &&
                      extStatus != null) {
                    //setAdminAccept();
                  }
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: (prsStatus != null &&
                            jobStatus != null &&
                            extStatus != null)
                        ? masterBlue
                        : Colors.orange[900],
                    //color: masterBlue,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'إنتظار القبول والموافقة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Waiting for acceptance and approval',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: englishFont,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.watch_later,
                            color: Colors.white,
                            size: 30.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
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
              accountName: Text(widget.currentUser.usrSalutationAr +
                  ' / ' +
                  widget.currentUser.usrName),
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
                    'نسخة التطبيق ' + '1.0.2',
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
      ),
    );
  }
}
