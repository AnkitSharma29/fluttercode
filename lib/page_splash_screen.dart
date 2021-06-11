import 'package:flutter/material.dart';
import 'package:mbo/wedgits/settings.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: masterBlue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              color: bgGray,
              child: Text(
                'مجموعة المنارة المتكاملة',
                style: TextStyle(
                  color: masterBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CircleAvatar(
              radius: 65.0,
              backgroundColor: bgGray,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Minarat Business Organization',
                style: TextStyle(
                  color: bgGray,
                  fontSize: 26,
                  fontFamily: 'Titillium',
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Text(
                  'نرجو الإنتظار...',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
