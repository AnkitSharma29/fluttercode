import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/main.dart';
import 'package:mbo/members/chatting/page_achat_home.dart';
import 'package:mbo/members/profile/page_profile_edit.dart';
import 'package:mbo/wedgits/cashImages.dart';

import 'events/evnts_ahome_page.dart';
import 'payment/pay_ahome_page.dart';

class MemberHomePage extends StatefulWidget {
  final MyUser currentUser;
  final VoidCallback doSignOut;
  final VoidCallback getSignInStatus;

  MemberHomePage(
      {this.currentUser, this.doSignOut, this.getSignInStatus, Key key})
      : super(key: key);

  @override
  _MemberHomePageState createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage>
    with WidgetsBindingObserver {
  String _projectVersion = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    didChangeAppLifecycleState(AppLifecycleState.resumed);
    getAppInformation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed || state == null) {
      usersRef.doc(widget.currentUser.usrId).update({'usrOnline': true});
    } else {
      usersRef.doc(widget.currentUser.usrId).update({'usrOnline': false});
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مجموعة المنارة المتكاملة'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Members Area Home Page',
              style: TextStyle(fontSize: 22.0),
            ),
            Text((widget.currentUser.usrSalutationAr != null)
                ? widget.currentUser.usrSalutationAr + ' / '
                : widget.currentUser.usrName),
            Text(widget.currentUser.usrName),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 45.0,
              backgroundImage: AssetImage('assets/images/logo.png'),
              child: myCachedNetworkImage(
                widget.currentUser.usrImage,
                myBorderRadius: 50.0,
              ),
            ),
            FlatButton(
              onPressed: () => widget.doSignOut(),
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              otherAccountsPictures: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
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
                ),
                IconButton(
                  icon: Icon(
                    Icons.adjust,
                    color: Colors.white,
                  ),
                  onPressed: () => widget.doSignOut(),
                ),
              ],
              accountName: Text(widget.currentUser.usrName),
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
              leading: Icon(
                Icons.pages,
              ),
              title: Text('المنتدى العام'),
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_today,
              ),
              title: Text('تقويم المناسبات'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MembersEventsHomePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.chat,
              ),
              title: Text('الدردشة الفورية'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatHomePage(
                      currentUser: widget.currentUser,
                    ),
                  ),
                );
              },
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
      ),
    );
  }
}
