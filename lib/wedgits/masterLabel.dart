import 'package:flutter/material.dart';
import 'package:mbo/wedgits/settings.dart';

class MasterLabel extends StatelessWidget {
  final Widget content;
  final Color theColor;

  const MasterLabel({this.content, Key key, this.theColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color myColor = (theColor != null) ? theColor : masterBlue;

    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: content,
        decoration: BoxDecoration(
          border: Border.all(color: myColor, width: 2.0),
          color: myColor,
          // borderRadius: BorderRadius.all(
          //   Radius.circular(5.0),
          // ),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.grey[500],
              blurRadius: 3.0,
              offset: new Offset(0.0, 3.0),
            ),
          ],
        ),
        //margin: EdgeInsets.all(5.0),
      ),
    );
  }
}
