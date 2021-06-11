import 'package:flutter/material.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/wedgits/cashImages.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';
import 'info_ext_edit.dart';

class InformationExtShowPage extends StatefulWidget {
  final MyUser currentUser;
  final VoidCallback getSignInStatus;
  InformationExtShowPage({this.currentUser, this.getSignInStatus, Key key})
      : super(key: key);

  @override
  _InformationExtShowPageState createState() => _InformationExtShowPageState();
}

class _InformationExtShowPageState extends State<InformationExtShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مجموعة المنارة المتكاملة'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (contextx) => SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: <Widget>[
                MasterLabel(
                  theColor: masterBlue,
                  content: Column(
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
                ),

///////////////////////////////////////

                SizedBox(
                  width: double.infinity,
                  child: MasterLabel(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'شعار الشركة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Company Logo',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: englishFont,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    theColor: darkGreen,
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: bgGray,
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/no-logo.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          (widget.currentUser.extComanyLogoImage != null)
                              ? myCachedNetworkImage(
                                  widget.currentUser.extComanyLogoImage,
                                  myBorderRadius: 75.0)
                              : Container(
                                  width: 0.0,
                                  height: 0.0,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),

////////////////////////////////////

                SizedBox(
                  width: double.infinity,
                  child: MasterLabel(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'صورة الهوية',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Idintity Photo',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: englishFont,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    theColor: darkGreen,
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: bgGray,
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/no-logo.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          (widget.currentUser.extIdentityImage != null)
                              ? myCachedNetworkImage(
                                  widget.currentUser.extIdentityImage,
                                  myBorderRadius: 0.0)
                              : Container(
                                  width: 0.0,
                                  height: 0.0,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),

// ///////////////////////////////////////

                SizedBox(
                  width: double.infinity,
                  child: MasterLabel(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'دافعك للحصول على العضوية',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Prompted for membership',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: englishFont,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    theColor: darkGreen,
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: bgGray,
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    widget.currentUser.extPrompted,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

// ///////////////////////////////////////

                SizedBox(
                  width: double.infinity,
                  child: MasterLabel(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'اسم معرفين من الأعضاء',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Named Two MBO Members',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: englishFont,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    theColor: darkGreen,
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: bgGray,
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    widget.currentUser.extMboMembers,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

// ///////////////////////////////////////
                SizedBox(
                  width: double.infinity,
                  child: MasterLabel(
                    content: Text(
                      'أتعهد بالأنظمة واللوائح الداخلية للمجموعة، وأن أمارس حقي كعضو فيها وفق ما هو متعارف عليه من عضو في مجموعات مشابهة. كما أتعهد بعدم نشر آراء المجموعة أو أعضائها إلا بعد الحصول على الموافقة المكتوبة المسبقة من مجلس إدارة المجموعة.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    theColor: darkGreen,
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: bgGray,
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    (widget.currentUser.extCommitment) ? 'موافق' : 'غير موافق',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

// ///////////////////////////////////////
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                ),

                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: darkGreen,
                      child: Text(
                        'تعديل المعلومات',
                      ),
                      onPressed: () {
                        //print('go to edit');
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InformationExtEditPage(
                              currentUser: widget.currentUser,
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
    );
  }
}
