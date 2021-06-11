import 'package:flutter/material.dart';
import 'package:mbo/admin/selections/page_cities_show.dart';
import 'package:mbo/admin/selections/page_countries_show.dart';
import 'package:mbo/admin/selections/page_maritalstatus_show.dart';
import 'package:mbo/admin/selections/page_salutation_show.dart';
import 'package:mbo/admin/selections/page_sectors_show.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';

import 'page_subscriptions_show.dart';

class SelectionsHomePage extends StatefulWidget {
  SelectionsHomePage({Key key}) : super(key: key);

  @override
  _SelectionsHomePageState createState() => _SelectionsHomePageState();
}

class _SelectionsHomePageState extends State<SelectionsHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة المتغيرات'),
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
                      theColor: darkGreen,
                      content: Text(
                        'إدارة المدن',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CitiesShowPage(),
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
                      theColor: darkGreen,
                      content: Text(
                        'إدارة الجنسيات',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CountriesShowPage(),
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
                      theColor: darkGreen,
                      content: Text(
                        'إدارة الحالة الإجتماعية',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MaritalStatusShowPage(),
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
                      theColor: darkGreen,
                      content: Text(
                        'إدارة الألقاب',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalutationShowPage(),
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
                      theColor: darkGreen,
                      content: Text(
                        'إدارة النشاطات التجارية',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SectorsShowPage(),
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
                      theColor: darkGreen,
                      content: Text(
                        'إدارة مدد الإشتراكات',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionsShowPage(),
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
