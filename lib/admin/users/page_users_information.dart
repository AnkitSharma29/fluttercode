import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/classes/User_Classification.dart';
import 'package:mbo/classes/date_formatter.dart';
import 'package:mbo/wedgits/cashImages.dart';
import 'package:mbo/wedgits/settings.dart';

import '../../main.dart';

class UsersInformationPage extends StatefulWidget {
  final MyUser theUser;
  UsersInformationPage({this.theUser, Key key}) : super(key: key);

  @override
  _UsersInformationPageState createState() => _UsersInformationPageState();
}

class _UsersInformationPageState extends State<UsersInformationPage> {
  String usrId;
  MyUser currentUser;
  String currentTitle;
  Color currentBackColor;
  Color currentForeColor;
  String currentType;
  String currentStatus;
  Map curUsr;
  @override
  void initState() {
    super.initState();
    currentUser = widget.theUser;
    usrId = currentUser.usrId;
    handleUserClassification();
  }

  handleUserClassification() {
    curUsr = getUserClassification(currentUser.usrType, currentUser.usrStatus);
    setState(() {
      currentTitle = curUsr['currentTitle'];
      currentBackColor = curUsr['currentBackColor'];
      currentForeColor = curUsr['currentForeColor'];
      currentType = curUsr['currentType'];
      currentStatus = curUsr['currentStatus'];
    });
  }

  getCurrentUserInfomation(uid) async {
    //print('getCurrentUserInfomation');
    await usersRef.doc(uid).get().then((DocumentSnapshot userInfo) {
      setState(() {
        currentUser = MyUser.fromDocument(userInfo);
        getUserInformation();
        getUserPersonalInformation();
        getUserWorkInformation();
        getUserExtraInformation();
        handleUserClassification();
      });
    });
  }

  Widget myRow(String title, content, {lang = arabicFont, color: 'b'}) {
    //Color myColor = (color == 'w') ? Colors.white : Colors.black;
    Color myColor = currentForeColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 100,
          child: Text(
            title,
            style: TextStyle(
              color: myColor,
              fontFamily: arabicFont,
              fontWeight: FontWeight.normal,
              fontSize: 12.0,
            ),
          ),
        ),
        Flexible(
          child: Text(
            content,
            style: TextStyle(
              color: myColor,
              fontFamily: lang,
              fontWeight: FontWeight.normal,
              fontSize: 12.0,
            ),
            textDirection:
                (lang == arabicFont) ? TextDirection.rtl : TextDirection.ltr,
          ),
        ),
      ],
    );
  }

  getUserInformation() {
    String usrId = currentUser.usrId;
    String usrEmail = currentUser.usrEmail;
    String usrImage = currentUser.usrImage;
    String usrName = currentUser.usrName;
    String usrSalutationAr = (currentUser.usrSalutationAr != null)
        ? currentUser.usrSalutationAr
        : '';
    String usrDateTime = (currentUser.usrDateTime != null)
        ? timestampTodate(currentUser.usrDateTime).toString()
        : 'غير معروف';
    return Card(
      color: currentBackColor,
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                'المعلومات الأساسية',
                style: TextStyle(
                  color: currentForeColor,
                ),
              ),
              Divider(
                color: currentForeColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    child: Text(
                      'صورة',
                      style: TextStyle(
                        fontFamily: arabicFont,
                        color: currentForeColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: myCachedNetworkImage(
                      usrImage,
                      myBorderRadius: 50.0,
                    ),
                  ),
                ],
              ),
              Divider(
                color: currentForeColor,
              ),
              myRow('اللقب', usrSalutationAr),
              myRow('الاسم', usrName),
              Divider(
                color: currentForeColor,
              ),
              myRow('رقم العضوية', usrId, lang: englishFont),
              myRow('تاريخ التسجيل', usrDateTime, lang: englishFont),
              myRow('البريد الإلكتروني', usrEmail, lang: englishFont),
              myRow('نوع المستخدم', currentType),
              myRow('حالة التسجيل', currentStatus),
            ],
          ),
        ),
      ),
    );
  }

  getUserPersonalInformation() {
    String prsEmail = currentUser.prsEmail;
    String prsCityNameAr = currentUser.prsCityNameAr;
    String prsFamilyName = currentUser.prsFamilyName;
    String prsFirstName = currentUser.prsFirstName;
    String prsFullEnglishName = currentUser.prsFullEnglishName;
    String prsHobbies = currentUser.prsHobbies;
    String prsHomeAddress = currentUser.prsHomeAddress;
    String prsInstagram = currentUser.prsInstagram;
    String prsMaritalStatusNameAr = currentUser.prsMaritalStatusNameAr;
    String prsMiddleName = currentUser.prsMiddleName;
    String prsNationalityNameAr = currentUser.prsNationalityNameAr;
    String prsPOBox = currentUser.prsPOBox;
    String prsTwitter = currentUser.prsTwitter;
    String prsZipCode = currentUser.prsZipCode;
    String prsBirthDay = (currentUser.prsBirthDay != null)
        ? timestampTodate(currentUser.prsBirthDay).toString()
        : 'غير معروف';
    bool prsStatus = currentUser.prsStatus;

    if (prsStatus == null || prsStatus == false) {
      //print('توجد بيانات');
      return Card(
        color: currentBackColor,
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'المعلومات الشخصية',
                  style: TextStyle(color: currentForeColor),
                ),
                Divider(
                  color: currentForeColor,
                ),
                Text(
                  'غير مكتملة',
                  style: TextStyle(color: currentForeColor),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      color: currentBackColor,
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                'المعلومات الشخصية',
                style: TextStyle(color: currentForeColor),
              ),
              Divider(
                color: Colors.white,
              ),
              myRow('الاسم الأول', prsFirstName, color: 'w'),
              myRow('اسم الأب', prsMiddleName, color: 'w'),
              myRow('اسم العائلة', prsFamilyName, color: 'w'),
              myRow('الاسم بالإنجليزية', prsFullEnglishName,
                  color: 'w', lang: englishFont),
              myRow('تاريخ الميلاد', prsBirthDay,
                  color: 'w', lang: englishFont),
              myRow('الجنسية', prsNationalityNameAr, color: 'w'),
              myRow('الحالة الإجتماعية', prsMaritalStatusNameAr, color: 'w'),
              Divider(
                color: Colors.white,
              ),
              myRow('المدينة', prsCityNameAr, color: 'w'),
              myRow('العنوان', prsHomeAddress, color: 'w'),
              myRow('صندوق البريد', prsPOBox, color: 'w', lang: englishFont),
              myRow('الرمز البريدي', prsZipCode, color: 'w', lang: englishFont),
              Divider(
                color: Colors.white,
              ),
              myRow('البريد الإلكتروني', prsEmail,
                  lang: englishFont, color: 'w'),
              myRow('انستجرام', prsInstagram, color: 'w', lang: englishFont),
              myRow('تويتر', prsTwitter, color: 'w', lang: englishFont),
              myRow('الهويات', prsHobbies, color: 'w'),
            ],
          ),
        ),
      ),
    );
  }

  getUserWorkInformation() {
    String jobAssistant = currentUser.jobAssistant;
    String jobCityNameAr = currentUser.jobCityNameAr;
    String jobCompanyEmail = currentUser.jobCompanyEmail;
    String jobCompanyName = currentUser.jobCompanyName;
    String jobCompanySectorNameAr = currentUser.jobCompanySectorNameAr;
    String jobCompanyTelephone = currentUser.jobCompanyTelephone;
    String jobEmail = currentUser.jobEmail;
    String jobLocation = currentUser.jobLocation;
    String jobMainBusiness = currentUser.jobMainBusiness;
    String jobMobile = currentUser.jobMobile;
    String jobPOBox = currentUser.jobPOBox;
    String jobPositions = currentUser.jobPositions;
    String jobTelephone = currentUser.jobTelephone;
    String jobTitle = currentUser.jobTitle;
    String jobWebsite = currentUser.jobWebsite;
    String jobZip = currentUser.jobZip;

    bool jobStatus = currentUser.jobStatus;

    if (jobStatus == null || jobStatus == false) {
      //print('توجد بيانات');
      return Card(
        color: currentBackColor,
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'معلومات العمل',
                  style: TextStyle(color: currentForeColor),
                ),
                Divider(
                  color: currentForeColor,
                ),
                Text(
                  'غير مكتملة',
                  style: TextStyle(color: currentForeColor),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      color: currentBackColor,
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                'معلومات العمل',
                style: TextStyle(color: currentForeColor),
              ),
              Divider(
                color: Colors.white,
              ),
              myRow('اسم الشركة', jobCompanyName, color: 'w'),
              myRow('المنصب', jobTitle, color: 'w'),
              myRow('موقع العمل', jobLocation, color: 'w'),
              myRow('جوال', jobMobile, color: 'w', lang: englishFont),
              myRow('المدينة', jobCityNameAr, color: 'w'),
              myRow('صندوق البريد', jobPOBox, color: 'w', lang: englishFont),
              myRow('الرمز البريدي', jobZip, color: 'w', lang: englishFont),
              myRow('هاتف العمل', jobCompanyTelephone,
                  color: 'w', lang: englishFont),
              myRow('بريد العمل', jobCompanyEmail,
                  color: 'w', lang: englishFont),
              Divider(
                color: Colors.white,
              ),
              myRow('المناصب', jobPositions, color: 'w'),
              Divider(
                color: Colors.white,
              ),
              myRow('النشاط الرئيسي', jobMainBusiness, color: 'w'),
              myRow('موقع إلكتروني', jobWebsite, color: 'w', lang: englishFont),
              myRow('مساعد المدير', jobAssistant, color: 'w'),
              myRow('البريد الإلكتروني', jobEmail,
                  color: 'w', lang: englishFont),
              myRow('هاتف', jobTelephone, color: 'w', lang: englishFont),
              myRow('قطاع الشركة', jobCompanySectorNameAr, color: 'w'),
            ],
          ),
        ),
      ),
    );
  }

  getUserExtraInformation() {
    String extComanyLogoImage = currentUser.extComanyLogoImage;
    String extIdentityImage = currentUser.extIdentityImage;
    String extMboMembers = currentUser.extMboMembers;
    String extPrompted = currentUser.extPrompted;
    String extCommitment =
        (currentUser.extCommitment == true) ? 'موافق' : 'غير موافق';

    bool extStatus = currentUser.extStatus;

    if (extStatus == null || extStatus == false) {
      //print('توجد بيانات');
      return Card(
        color: currentBackColor,
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'تفاصيل إضافية',
                  style: TextStyle(
                    color: currentForeColor,
                  ),
                ),
                Divider(
                  color: currentForeColor,
                ),
                Text(
                  'غير مكتملة',
                  style: TextStyle(
                    color: currentForeColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      color: currentBackColor,
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                'تفاصيل إضافية',
                style: TextStyle(
                  color: currentForeColor,
                ),
              ),
              Divider(
                color: currentForeColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    child: Text(
                      'شعار الشركة',
                      style: TextStyle(
                        fontFamily: arabicFont,
                        color: currentForeColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: myCachedNetworkImage(
                      extComanyLogoImage,
                      myBorderRadius: 50.0,
                    ),
                  ),
                ],
              ),
              Divider(
                color: currentForeColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    child: Text(
                      'الهوية الشخصية',
                      style: TextStyle(
                        fontFamily: arabicFont,
                        color: currentForeColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: myCachedNetworkImage(
                      extIdentityImage,
                    ),
                  ),
                ],
              ),
              Divider(
                color: currentForeColor,
              ),
              myRow('أعضاء مزكين', extMboMembers),
              myRow('الدافع للعضوية', extPrompted),
              myRow('موافقة وتعهد', extCommitment),
            ],
          ),
        ),
      ),
    );
  }

  handleDeniedAction() {
    usersRef.doc(usrId).update({'usrType': 0}).then(
      (value) => getCurrentUserInfomation(usrId),
    );
  }

  handleUnDeniedAction() {
    usersRef.doc(usrId).update({'usrType': 1}).then(
      (value) => getCurrentUserInfomation(usrId),
    );
  }

  handleAccesptAction() {
    usersRef.doc(usrId).update({'usrStatus': 0}).then(
      (value) => getCurrentUserInfomation(usrId),
    );
  }

  handleUnAccesptAction() {
    usersRef.doc(usrId).update({'usrStatus': -1}).then(
      (value) => getCurrentUserInfomation(usrId),
    );
  }

  popUp() {
    List<CupertinoActionSheetAction> theActions = [];
    CupertinoActionSheetAction deniedAction = CupertinoActionSheetAction(
      child: const Text(
        'حظر المستخدم',
        style: TextStyle(
          color: masterBlue,
          fontFamily: arabicFont,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        handleDeniedAction();
      },
    );

    CupertinoActionSheetAction accesptAction = CupertinoActionSheetAction(
      child: const Text(
        'قبول طلب الإشتراك',
        style: TextStyle(
          color: masterBlue,
          fontFamily: arabicFont,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        handleAccesptAction();
      },
    );
    CupertinoActionSheetAction unAccesptAction = CupertinoActionSheetAction(
      child: const Text(
        'رفض طلب الإشتراك',
        style: TextStyle(
          color: masterBlue,
          fontFamily: arabicFont,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        handleUnAccesptAction();
      },
    );

    CupertinoActionSheetAction accesptPaymentAction =
        CupertinoActionSheetAction(
      child: const Text(
        'الإجرائات المالية للإشتراك',
        style: TextStyle(
          color: masterBlue,
          fontFamily: arabicFont,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        handleAccesptAction();
      },
    );

    CupertinoActionSheetAction undeniedAction = CupertinoActionSheetAction(
      child: const Text(
        'رفع الحظر',
        style: TextStyle(
          color: masterBlue,
          fontFamily: arabicFont,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        handleUnDeniedAction();
      },
    );

    switch (currentUser.usrType) {
      // DENID
      case 0:
        theActions = [
          undeniedAction,
        ];
        break;
      // MEMBER
      case 1:
        switch (currentUser.usrStatus) {
          // NOT COMPLETED INFORMATION
          case -2:
            theActions = [
              accesptAction,
              deniedAction,
            ];
            break;
          // COMPLETE INFORMATION
          case -1:
            theActions = [
              accesptAction,
              deniedAction,
            ];
            break;
          // PAYMENT ACTION
          case 0:
            theActions = [
              unAccesptAction,
              accesptPaymentAction,
              deniedAction,
            ];
            break;
          // ACTIVE MEMBER
          case 1:
            theActions = [
              deniedAction,
            ];
            break;
          default:
            theActions = [];
        }

        break;
      default:
        theActions = [];
    }

    // List<CupertinoActionSheetAction> newUser = [
    //   deniedAction,
    // ];

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'إجرائات المستخدمين',
          style: TextStyle(
            fontFamily: arabicFont,
          ),
        ),
        actions: theActions,
        cancelButton: CupertinoActionSheetAction(
          child: const Text(
            'إلغاء',
            style: TextStyle(
              color: bgGray,
              fontFamily: arabicFont,
            ),
          ),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentTitle,
          style: TextStyle(
            color: currentForeColor,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: currentBackColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_moderator,
              color: currentForeColor,
            ),
            onPressed: () => popUp(),
          ),
        ],
        //shadowColor: foreColor,
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
                getUserInformation(),
                getUserPersonalInformation(),
                getUserWorkInformation(),
                getUserExtraInformation(),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton.icon(
                    icon: Icon(
                      Icons.money_sharp,
                      color: Colors.red,
                    ),
                    label: new Text(
                      'التفاصيل المالية',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () => null,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.red,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton.icon(
                    icon: Icon(
                      Icons.add_moderator,
                      color: masterBlue,
                    ),
                    label: new Text(
                      'الإجرائات',
                      style: TextStyle(
                        color: masterBlue,
                      ),
                    ),
                    onPressed: () => popUp(),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: masterBlue,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(50),
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
