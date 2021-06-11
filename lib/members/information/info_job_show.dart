import 'package:flutter/material.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';
import 'info_Job_edit.dart';

class InformationJobShowPage extends StatefulWidget {
  final MyUser currentUser;
  final VoidCallback getSignInStatus;
  InformationJobShowPage({this.currentUser, this.getSignInStatus, Key key})
      : super(key: key);

  @override
  _InformationJobShowPageState createState() => _InformationJobShowPageState();
}

class _InformationJobShowPageState extends State<InformationJobShowPage> {
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
                ),

///////////////////////////////////////
                SizedBox(
                  width: double.infinity,
                  child: MasterLabel(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'اسم الشركة بالكامل',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Full Company Name',
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
                    widget.currentUser.jobCompanyName,
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
                          'المنصب',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Job Title',
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
                    widget.currentUser.jobTitle,
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
                          'موقع العمل',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Office Location',
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
                    widget.currentUser.jobLocation,
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
                          'الجوال',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Mobile',
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
                    widget.currentUser.jobMobile,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
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
                          'المدينة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'City',
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
                    widget.currentUser.jobCityNameAr +
                        ' / ' +
                        widget.currentUser.prsCityNameEn,
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
                          'صندوق البريد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'P.O. Box',
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
                    widget.currentUser.jobPOBox,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
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
                          'الرمز البريدي',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Zip Code',
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
                    widget.currentUser.jobZip,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
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
                          'الهاتف',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Telephone No',
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
                    widget.currentUser.jobTelephone,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
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
                          'البريد الإلكتروني',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'E-Mail',
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
                    widget.currentUser.jobCompanyEmail,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
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
                          'المناصب',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Positions',
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
                    widget.currentUser.jobPositions,
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
                          'النشاط التجاري الرئيسي',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Main Bussiness',
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
                    widget.currentUser.jobMainBusiness,
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
                          'الموقع الإلكتروني',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Company Website',
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
                    widget.currentUser.jobWebsite,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
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
                          'الهاتف',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Telephone No',
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
                    widget.currentUser.jobCompanyTelephone,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
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
                          'اسم المساعد أومدير المكتب',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Assistant or Secertary',
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
                    widget.currentUser.jobAssistant,
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
                          'البريد الإلكتروني',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'E-mail',
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
                    widget.currentUser.jobCompanyEmail,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
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
                          'قطاع الشركة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Company Sector',
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
                    widget.currentUser.jobCompanySectorNameAr +
                        ' / ' +
                        widget.currentUser.jobCompanySectorNameEn,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

////////////////////////////////////////
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
                            builder: (context) => InformationJobEditPage(
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
