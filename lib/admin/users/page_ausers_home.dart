import 'package:flutter/material.dart';
import 'package:mbo/classes/User_Classification.dart';
import 'package:mbo/wedgits/masterLabel.dart';

import 'page_users_list.dart';

class UsersHomePage extends StatefulWidget {
  UsersHomePage({Key key}) : super(key: key);

  @override
  _UsersHomePageState createState() => _UsersHomePageState();
}

class _UsersHomePageState extends State<UsersHomePage> {
  Map memNotComp;
  Map memComp;
  Map memNotSub;
  Map memSub;
  Map memDenied;
  Map memAll;
  @override
  void initState() {
    super.initState();
    memNotComp = getUserClassification(1, -2);
    memComp = getUserClassification(1, -1);
    memNotSub = getUserClassification(1, 0);
    memSub = getUserClassification(1, 1);
    memDenied = getUserClassification(0, 0);
    memAll = getUserClassification(10, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة المستخدمين'),
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
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: MasterLabel(
                      theColor: memNotComp['currentBackColor'],
                      content: Text(
                        'عضو - غير مكتمل البيانات',
                        style: TextStyle(
                          color: memNotComp['currentForeColor'],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersListPage(
                          usrType: 1,
                          usrStatus: -2,
                          title: 'عضو - غير مكتمل البيانات',
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: MasterLabel(
                      theColor: memComp['currentBackColor'],
                      content: Text(
                        'عضو - مكتمل البيانات',
                        style: TextStyle(
                          color: memComp['currentForeColor'],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersListPage(
                          usrType: 1,
                          usrStatus: -1,
                          title: 'عضو - مكتمل البيانات',
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: MasterLabel(
                      theColor: memNotSub['currentBackColor'],
                      content: Text(
                        'عضو - غير مشترك',
                        style: TextStyle(
                          color: memNotSub['currentForeColor'],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersListPage(
                          usrType: 1,
                          usrStatus: 0,
                          title: 'عضو - غير مشترك',
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: MasterLabel(
                      theColor: memSub['currentBackColor'],
                      content: Text(
                        'عضو - مشترك',
                        style: TextStyle(
                          color: memSub['currentForeColor'],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersListPage(
                          usrType: 1,
                          usrStatus: 1,
                          title: 'عضو - مشترك',
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: MasterLabel(
                      theColor: memDenied['currentBackColor'],
                      content: Text(
                        'عضو - محظور',
                        style: TextStyle(
                          color: memDenied['currentForeColor'],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersListPage(
                          usrType: 0,
                          usrStatus: 0,
                          title: 'عضو - محظور',
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: MasterLabel(
                      theColor: memAll['currentBackColor'],
                      content: Text(
                        'الجميع غير محدد',
                        style: TextStyle(
                          color: memAll['currentForeColor'],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersListPage(
                          usrType: 10,
                          usrStatus: 10,
                          title: 'الجميع غير محدد',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
