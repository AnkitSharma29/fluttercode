import 'package:flutter/material.dart';
import 'package:mbo/admin/selections/page_aselections_home.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/classes/auth_by_email.dart';
import 'package:mbo/wedgits/cashImages.dart';

import 'events/page_aevents_home.dart';
import 'users/page_ausers_home.dart';

class AdminHomePage extends StatefulWidget {
  final EmailAuth auth;
  final MyUser currentUser;
  final VoidCallback doSignOut;
  AdminHomePage({this.auth, this.doSignOut, this.currentUser, Key key})
      : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مجموعة المنارة المتكاملة'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Text(widget.currentUser.usrName),
              //Text(widget.currentUser.usrImage.toString()),
              //myCachedNetworkImage(widget.currentUser.usrImage),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 45.0,
                backgroundImage: AssetImage('assets/images/logo.png'),
                child: myCachedNetworkImage(
                  widget.currentUser.usrImage,
                  myBorderRadius: 50.0,
                ),
              ),

              Text(DateTime.now().toString()),
              //Text(Timestamp.now().toString()),
              //Text(timestampTodate(widget.currentUser.usrDateTime)),
              //Text(timestampTotime(widget.currentUser.usrDateTime)),

              FlatButton(
                onPressed: () => widget.doSignOut(),
                child: Text('Sign Out'),
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
                Icon(
                  Icons.adjust,
                  color: Colors.white,
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
              leading: Icon(Icons.select_all),
              title: Text('إدارة المتغيرات'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectionsHomePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people_outline),
              title: Text('إدارة المستخدمين'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersHomePage(),
                  ),
                );
              },
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
                    builder: (context) => EventsHomePage(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.attach_money,
              ),
              title: Text('التقارير'),
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
