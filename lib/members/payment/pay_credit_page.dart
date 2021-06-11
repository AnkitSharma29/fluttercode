import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/members/profile/page_profile_edit.dart';
import 'package:mbo/wedgits/cashImages.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/settings.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart' as myfatoorah;
import '../../main.dart';
import 'pay_ahome_page.dart';

class PaymentCreditPage extends StatefulWidget {
  final MyUser currentUser;
  final VoidCallback doSignOut;
  final VoidCallback getSignInStatus;
  final packgeRecord;

  PaymentCreditPage(
      {this.currentUser,
      this.getSignInStatus,
      this.doSignOut,
      this.packgeRecord,
      Key key})
      : super(key: key);

  @override
  _PaymentCreditPageState createState() => _PaymentCreditPageState();
}

class _PaymentCreditPageState extends State<PaymentCreditPage> {
  String _projectVersion = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _autoValidate = AutovalidateMode.disabled;
  String transactionErrorMessage;
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController securityCodeController = TextEditingController();
  TextEditingController expirationController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController expiryMonthController = TextEditingController();
  TextEditingController expiryYearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myfatoorah.MFSDK.init(baseUrl, directPaymentToken);
    getAppInformation();
    getFormData();
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

  getFormData() {
    cardHolderNameController.text =
        widget.currentUser.prsFullEnglishName.toUpperCase();

    //temperriory
    cardNumberController.text = '2223000000000007';
    expiryMonthController.text = '05';
    expiryYearController.text = '21';
    securityCodeController.text = '100';
  }

  handleCreditCardPayment() {
    String _paymentMethod = "2";
    String _paymentAmount = widget.packgeRecord['subAmount'].toString();

    String _cardNumber = cardNumberController.text;
    String _expiryMonth = expiryMonthController.text;
    String _expiryYear = expiryYearController.text;
    String _securityCode = securityCodeController.text;
    String _cardHolderName = cardHolderNameController.text;
    bool _bypass3DS = true;
    bool _saveToken = true;
    Map transactionFeedBack;
    Dialogs.showLoadingDialog(context, _keyLoader);
    var request =
        new myfatoorah.MFExecutePaymentRequest(_paymentMethod, _paymentAmount);
    var mfCardInfo = new myfatoorah.MFCardInfo(
        cardNumber: _cardNumber,
        expiryMonth: _expiryMonth,
        expiryYear: _expiryYear,
        securityCode: _securityCode,
        cardHolderName: _cardHolderName,
        bypass3DS: _bypass3DS,
        saveToken: _saveToken);

    myfatoorah.MFSDK.executeDirectPayment(
        context, request, mfCardInfo, myfatoorah.MFAPILanguage.EN,
        (String invoiceId,
            myfatoorah.MFResult<myfatoorah.MFDirectPaymentResponse> result) {
      if (result.isSuccess()) {
        //print(invoiceId);
        //print(result.response.toJson());
        transactionFeedBack = result.response.toJson();
        handleTransaction(transactionFeedBack);
      } else {
        //setState(() {
        //print(invoiceId);
        //print(result.error.toJson());
        transactionErrorMessage =
            (result.error.message != null) ? result.error.message : null;
        //})
        Navigator.of(context, rootNavigator: true).pop();
        Dialogs.alertDialog(
            context, 'نأسف. لم تتم عملية الإشتراك والدفع الإلكتروني');
      }
    });
  }

  handleTransaction(
    transactionFeedBack,
  ) {
    _formKey.currentState.reset();
    setState(() {
      _autoValidate = AutovalidateMode.disabled;
    });

    DocumentReference ref = usersRef.doc();
    String _payId = ref.id;

    int _days = widget.packgeRecord['subDays'];

    DateTime _payDateTime = DateTime.now();
    DateTime _payDateStart = DateTime.now();
    DateTime _payDateEnd = _payDateStart.add(Duration(days: _days));

    if (widget.currentUser.usrStatus == 1) {
      int dateComparing = _payDateTime
          .difference(widget.currentUser.payDateEnd.toDate())
          .inDays;

      if (dateComparing <= 0) {
        _payDateStart = widget.currentUser.payDateEnd.toDate();
        _payDateEnd =
            widget.currentUser.payDateEnd.toDate().add(Duration(days: _days));
      }
    }

    usersRef
        .doc(widget.currentUser.usrId)
        .collection('payments')
        .doc(_payId)
        .set(transactionFeedBack)
        .then((value) {
      if (transactionFeedBack['cardInfoResponse']['Status'] == 'SUCCESS') {
        usersRef.doc(widget.currentUser.usrId).update({
          'subId': widget.packgeRecord['subId'],
          'subAmount': widget.packgeRecord['subAmount'],
          'subAr': widget.packgeRecord['subAr'],
          'subDays': widget.packgeRecord['subDays'],
          'subEn': widget.packgeRecord['subEn'],
          'payId': _payId,
          'payDateTime': _payDateTime,
          'payDateStart': _payDateStart,
          'payDateEnd': _payDateEnd,
          'usrStatus': 1,
        }).then((tvalue) async {
          Navigator.of(context, rootNavigator: true).pop();
          await Dialogs.alertDialog(
                  context, 'لقد تمت عملية الإشتراك والدفع الإلكتروني بنجاح')
              .then((val) {
            Navigator.pop(context);
            if (widget.currentUser.usrStatus == 1) {
              Navigator.pop(context);
              Navigator.pop(context);
            }
            widget.getSignInStatus();
          });
        }).catchError((onError) {
          Navigator.of(context, rootNavigator: true).pop();
        });
      }
    }).catchError((onError) {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('مجموعة المنارة المتكاملة'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (contextx) => SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 15.0),
                    child: Card(
                      child: ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              (widget.packgeRecord['subAr'] != null)
                                  ? widget.packgeRecord['subAr']
                                  : 'غير متوفر',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Divider(),
                            Text(
                              (widget.packgeRecord['subAmount'] != null)
                                  ? widget.packgeRecord['subAmount']
                                          .toString() +
                                      ' ريال سعودي '
                                  : '0',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: englishFont,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        subtitle: Text(
                          (widget.packgeRecord['subDays'] != null)
                              ? widget.packgeRecord['subDays'].toString() +
                                  ' يوم '
                              : 'غير متوفر',
                          style: TextStyle(
                            fontFamily: englishFont,
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                        ),
                        trailing: Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: bgGray,
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Icon(Icons.payment_outlined),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 15.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 2.0),
                              child: Text(
                                'معلومات بطاقة الإتمان',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                              child: TextFormField(
                                controller: cardHolderNameController,
                                keyboardType: TextInputType.name,
                                autocorrect: false,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(fontFamily: englishFont),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "اسم حامل البطاقة",
                                  labelStyle: TextStyle(fontFamily: arabicFont),
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'الحقل مطلوب';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                              child: TextFormField(
                                controller: cardNumberController,
                                keyboardType: TextInputType.number,
                                autocorrect: false,
                                textDirection: TextDirection.ltr,
                                maxLength: 16,
                                style: TextStyle(fontFamily: englishFont),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "رقم البطاقة",
                                  labelStyle: TextStyle(fontFamily: arabicFont),
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'الحقل مطلوب';
                                  }
                                  if (value.length < 16) {
                                    return 'غير مطابق';
                                  }

                                  int sum = 0;
                                  int length = value.length;
                                  for (var i = 0; i < length; i++) {
                                    // get digits in reverse order
                                    int digit =
                                        int.parse(value[length - i - 1]);
                                    // every 2nd number multiply with 2
                                    if (i % 2 == 1) {
                                      digit *= 2;
                                    }
                                    sum += digit > 9 ? (digit - 9) : digit;
                                  }

                                  if (sum % 10 != 0) {
                                    return 'تأكد من رقم البطاقة';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                              child: TextFormField(
                                controller: securityCodeController,
                                keyboardType: TextInputType.number,
                                autocorrect: false,
                                textDirection: TextDirection.ltr,
                                maxLength: 3,
                                style: TextStyle(fontFamily: englishFont),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "الرقم خلف البطاقة",
                                  labelStyle: TextStyle(fontFamily: arabicFont),
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'الحقل مطلوب';
                                  }
                                  if (value.length < 3) {
                                    return 'غير مطابق';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: (screenWidth / 2) - 45,
                                    child: TextFormField(
                                      controller: expiryMonthController,
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      maxLength: 2,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(fontFamily: englishFont),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "شهر",
                                        hintText: '00',
                                        labelStyle:
                                            TextStyle(fontFamily: arabicFont),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'الحقل مطلوب';
                                        }
                                        if (int.parse(value) <= 0 ||
                                            int.parse(value) > 12) {
                                          return 'غير مطابق';
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: (screenWidth / 2) - 45,
                                    child: TextFormField(
                                      controller: expiryYearController,
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      textDirection: TextDirection.ltr,
                                      maxLength: 2,
                                      style: TextStyle(fontFamily: englishFont),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "سنة",
                                        hintText: '00',
                                        alignLabelWithHint: true,
                                        labelStyle:
                                            TextStyle(fontFamily: arabicFont),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'الحقل مطلوب';
                                        }
                                        if (int.parse(value) <= 0) {
                                          return 'غير مطابق';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  child: Text(
                                    'إجراء عملية الدفع',
                                  ),
                                  color: Colors.red[600],
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      if (expiryMonthController
                                              .text.isNotEmpty &&
                                          expiryMonthController.text.length <
                                              2) {
                                        expiryMonthController.text =
                                            '0' + expiryMonthController.text;
                                      }
                                      if (expiryYearController
                                              .text.isNotEmpty &&
                                          expiryYearController.text.length <
                                              2) {
                                        expiryYearController.text =
                                            '0' + expiryYearController.text;
                                      }

                                      _formKey.currentState.save();
                                      handleCreditCardPayment();
                                    } else {
                                      Scaffold.of(contextx).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'نرجو التأكد من المعلومات المسجلة',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        _autoValidate = AutovalidateMode.always;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: (widget.currentUser.usrStatus == 0)
          ? Drawer(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    otherAccountsPictures: [
                      IconButton(
                        icon: Icon(
                          Icons.adjust,
                          color: Colors.white,
                        ),
                        onPressed: () => widget.doSignOut(),
                      ),
                    ],
                    accountName: Text(
                        (widget.currentUser.usrSalutationAr != null)
                            ? widget.currentUser.usrSalutationAr + ' / '
                            : widget.currentUser.usrName),
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
            )
          : null,
    );
  }
}
