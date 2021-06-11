import 'package:flutter/material.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/classes/date_formatter.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';

import 'info_personal_edit.dart';

class InformationPersonalShowPage extends StatefulWidget {
  final MyUser currentUser;
  final VoidCallback getSignInStatus;
  InformationPersonalShowPage({this.currentUser, this.getSignInStatus, Key key})
      : super(key: key);

  @override
  _InformationPersonalShowPageState createState() =>
      _InformationPersonalShowPageState();
}

class _InformationPersonalShowPageState
    extends State<InformationPersonalShowPage> {
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
                ),

///////////////////////////////////////
                SizedBox(
                  width: double.infinity,
                  child: MasterLabel(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'الاسم الأول',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'First Name',
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
                    widget.currentUser.prsFirstName,
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
                          'اسم الأب',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Middle Name',
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
                    widget.currentUser.prsMiddleName,
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
                          'اسم العائلة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Last Name',
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
                    widget.currentUser.prsFamilyName,
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
                          'الاسم كاملا بالإنجليزية',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Full Name in English',
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
                    widget.currentUser.prsFullEnglishName,
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
                          'تاريخ الميلاد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Date of Birth',
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
                    timestampTodate(widget.currentUser.prsBirthDay),
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
                          'الحالة الإجتماعي',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Marital Status',
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
                    widget.currentUser.prsMaritalStatusNameAr +
                        ' / ' +
                        widget.currentUser.prsMaritalStatusNameEn,
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
                          'الجنسية',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Nationality',
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
                    widget.currentUser.prsNationalityNameAr +
                        ' / ' +
                        widget.currentUser.prsNationalityNameEn,
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
                          'العنوان',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Home Address',
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
                    widget.currentUser.prsHomeAddress,
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
                    widget.currentUser.prsCityNameAr +
                        ' / ' +
                        widget.currentUser.prsCityNameEn,
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
                    widget.currentUser.prsPOBox,
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
                    widget.currentUser.prsZipCode,
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
                    widget.currentUser.prsTelephone,
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
                          'البريد الإلكتروني الشخصي',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Personal E-mail',
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
                    widget.currentUser.prsEmail,
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
                          'إنستقرام',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Instagram',
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
                    widget.currentUser.prsInstagram,
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
                          'تويتر',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Instagram',
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
                    widget.currentUser.prsTwitter,
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
                          'الهوايات ولاهتمامات',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Hobbies & Interests',
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
                    widget.currentUser.prsHobbies,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                  ),
                ),

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
                            builder: (context) => InformationPersonalEditPage(
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
