import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/classes/date_formatter.dart';
import 'package:mbo/classes/input_validator.dart';
import 'package:mbo/main.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';

class InformationPersonalAddPage extends StatefulWidget {
  final MyUser currentUser;
  final VoidCallback getSignInStatus;

  InformationPersonalAddPage({this.currentUser, this.getSignInStatus, Key key})
      : super(key: key);

  @override
  _InformationPersonalAddPageState createState() =>
      _InformationPersonalAddPageState();
}

// class Item {
//   const Item(this.name);
//   final String name;
// }

class _InformationPersonalAddPageState
    extends State<InformationPersonalAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _autoValidate = AutovalidateMode.disabled;
  //String _errorMasseges;

  final prsFirstNameController = TextEditingController();
  final prsMiddleNameController = TextEditingController();
  final prsFamilyNameController = TextEditingController();
  final prsFullEnglishNameController = TextEditingController();
  final prsBirthDayController = TextEditingController();
  final prsHomeAddressController = TextEditingController();
  final prsPOBoxController = TextEditingController();
  final prsZipCodeController = TextEditingController();
  final prsTelephoneController = TextEditingController();
  final prsEmailController = TextEditingController();
  final prsInstagramController = TextEditingController();
  final prsTwitterController = TextEditingController();
  final prsHobbiesController = TextEditingController();

  String prsMaritalStatusController;
  List<DropdownMenuItem<String>> maritalStatus = [];
  Map mapMaritalStatus = {};

  String prsNationalityController;
  List<DropdownMenuItem<String>> nationality = [];
  Map mapNationality = {};

  String prsCityController;
  List<DropdownMenuItem<String>> city = [];
  Map mapCity = {};

  @override
  void initState() {
    super.initState();
    loadFormData();
  }

  loadFormData() async {
    //print('loadFormData loadFormData loadFormData');
    mapMaritalStatus = {};
    maritalStatus = [];
    await lookUpMaritalStatusRef.get().then((doc) {
      doc.docs.forEach((doc) {
        mapMaritalStatus[doc.id] = {
          'mrtId': doc.id,
          'mrtAr': doc.data()['mrtAr'],
          'mrtEn': doc.data()['mrtEn'],
        };
        maritalStatus.add(
          DropdownMenuItem(
            value: doc.id,
            child: Text(
              doc.data()['mrtAr'] + ' / ' + doc.data()['mrtEn'],
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      });
    }).whenComplete(() {
      setState(() {
        maritalStatus = maritalStatus;
      });
    });

    mapNationality = {};
    nationality = [];
    await lookUpCountriesRef.get().then((doc) {
      doc.docs.forEach((doc) {
        mapNationality[doc.id] = {
          'cntId': doc.id,
          'cntAr': doc.data()['cntAr'],
          'cntEn': doc.data()['cntEn'],
        };
        nationality.add(
          DropdownMenuItem(
            value: doc.id,
            child: Text(
              doc.data()['cntAr'] + ' / ' + doc.data()['cntEn'],
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      });
    }).whenComplete(() {
      setState(() {
        nationality = nationality;
      });
    });

    mapCity = {};
    city = [];
    await lookUpCitiesRef.get().then((doc) {
      doc.docs.forEach((doc) {
        mapCity[doc.id] = {
          'ctyId': doc.id,
          'ctyAr': doc.data()['ctyAr'],
          'ctyEn': doc.data()['ctyEn'],
        };
        city.add(
          DropdownMenuItem(
            value: doc.id,
            child: Text(
              doc.data()['ctyAr'] + ' / ' + doc.data()['ctyEn'],
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      });
    }).whenComplete(() {
      setState(() {
        city = city;
      });
    });
  }

  handleUpdatePersonalData() {
    //print(' handleSavePersonalData handleSavePersonalData');

    bool _prsStatus = true;
    String _prsFirstName = prsFirstNameController.text;
    String _prsMiddleName = prsMiddleNameController.text;
    String _prsFamilyName = prsFamilyNameController.text;
    String _prsFullEnglishName = prsFullEnglishNameController.text;
    DateTime _prsBirthDay = DateTime.parse(prsBirthDayController.text);
    String _prsHomeAddress = prsHomeAddressController.text;
    String _prsPOBox = prsPOBoxController.text;
    String _prsZipCode = prsZipCodeController.text;
    String _prsTelephone = prsTelephoneController.text;
    String _prsEmail = prsEmailController.text;
    String _prsInstagram = prsInstagramController.text;
    String _prsTwitter = prsTwitterController.text;
    String _prsHobbies = prsHobbiesController.text;

    String _prsMaritalStatusId =
        mapMaritalStatus[prsMaritalStatusController]['mrtId'];
    String _prsMaritalStatusNameAr =
        mapMaritalStatus[prsMaritalStatusController]['mrtAr'];
    String _prsMaritalStatusNameEn =
        mapMaritalStatus[prsMaritalStatusController]['mrtEn'];
    //prsMaritalStatusController.toString();
    String _prsNationalityId =
        mapNationality[prsNationalityController]['cntId'];
    String _prsNationalityNameAr =
        mapNationality[prsNationalityController]['cntAr'];
    String _prsNationalityNameEn =
        mapNationality[prsNationalityController]['cntEn'];

    String _prsCityId = mapCity[prsCityController]['ctyId'];
    String _prsCityNameAr = mapCity[prsCityController]['ctyAr'];
    String _prsCityNameEn = mapCity[prsCityController]['ctyEn'];

    Dialogs.showLoadingDialog(context, _keyLoader);
    usersRef.doc(widget.currentUser.usrId).update({
      'prsStatus': _prsStatus,
      'prsFirstName': _prsFirstName,
      'prsMiddleName': _prsMiddleName,
      'prsFamilyName': _prsFamilyName,
      'prsFullEnglishName': _prsFullEnglishName,
      'prsBirthDay': _prsBirthDay,
      'prsMaritalStatusId': _prsMaritalStatusId,
      'prsMaritalStatusNameAr': _prsMaritalStatusNameAr,
      'prsMaritalStatusNameEn': _prsMaritalStatusNameEn,
      'prsNationalityId': _prsNationalityId,
      'prsNationalityNameAr': _prsNationalityNameAr,
      'prsNationalityNameEn': _prsNationalityNameEn,
      'prsHomeAddress': _prsHomeAddress,
      'prsCityId': _prsCityId,
      'prsCityNameAr': _prsCityNameAr,
      'prsCityNameEn': _prsCityNameEn,
      'prsPOBox': _prsPOBox,
      'prsZipCode': _prsZipCode,
      'prsTelephone': _prsTelephone,
      'prsEmail': _prsEmail,
      'prsInstagram': _prsInstagram,
      'prsTwitter': _prsTwitter,
      'prsHobbies': _prsHobbies,
    }).then((onValue) async {
      Navigator.of(context, rootNavigator: true).pop();

      _formKey.currentState.reset();
      setState(() {
        prsCityController = null;
        prsNationalityController = null;
        prsMaritalStatusController = null;
        _autoValidate = AutovalidateMode.disabled;
      });
      //Dialogs.alertDialog(context, 'لقد تم إعداد وحفظ المعلومات الشخصية بنجاح');
      await Dialogs.alertDialog(
              context, 'لقد تم إعداد وحفظ المعلومات الشخصية بنجاح')
          .then((val) {
        widget.getSignInStatus();
        Navigator.pop(context);
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1925, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        prsBirthDayController.text = dateTimeToDate(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مجموعة المنارة المتكاملة'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (contextx) => SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidate,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                width: double.infinity,
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

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: TextFormField(
                        autocorrect: false,
                        controller: prsFirstNameController,
                        decoration: InputDecoration(
                          labelText: 'الاسم الأول' + ' / ' + 'First Name',
                          hintText: 'الاسم الأول' + ' / ' + 'First Name',
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return null;
                        },
                      ),
                    ),

///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: TextFormField(
                        autocorrect: false,
                        controller: prsMiddleNameController,
                        decoration: InputDecoration(
                          labelText: 'اسم الأب' + ' / ' + 'Middle Name',
                          hintText: 'اسم الأب' + ' / ' + 'Middle Name',
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return null;
                        },
                      ),
                    ),
///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: TextFormField(
                        autocorrect: false,
                        controller: prsFamilyNameController,
                        decoration: InputDecoration(
                          labelText: 'اسم العائلة' + ' / ' + 'Last Name',
                          hintText: 'اسم العائلة' + ' / ' + 'Last Name',
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return null;
                        },
                      ),
                    ),
///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: TextFormField(
                        autocorrect: false,
                        controller: prsFullEnglishNameController,
                        decoration: InputDecoration(
                          labelText: 'الاسم كاملا بالإنجليزية' +
                              ' / ' +
                              'Full Name in English',
                          hintText: 'الاسم كاملا بالإنجليزية' +
                              ' / ' +
                              'Full Name in English',
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return null;
                        },
                      ),
                    ),
///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: TextFormField(
                        autocorrect: false,
                        controller: prsBirthDayController,
                        decoration: InputDecoration(
                          labelText: 'تاريخ الميلاد' + ' / ' + 'Date of Birth',
                          hintText: 'تاريخ الميلاد' + ' / ' + 'Date of Birth',
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return null;
                        },
                        onTap: () => _selectDate(context),
                      ),
                    ),
///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: DropdownButtonFormField(
                        value: prsMaritalStatusController,
                        decoration: InputDecoration(
                          labelText:
                              'الحالة الإجتماعي' + ' / ' + 'Marital Status',
                          hintText:
                              'الحالة الإجتماعي' + ' / ' + 'Marital Status',
                        ),
                        items: maritalStatus.toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return maritalStatus.toList();
                        },
                        onChanged: (value) {
                          setState(() {
                            prsMaritalStatusController = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return null;
                        },
                      ),
                    ),
///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: DropdownButtonFormField(
                        value: prsNationalityController,
                        decoration: InputDecoration(
                          labelText: 'الجنسية' + ' / ' + 'Nationality',
                          hintText: 'الجنسية' + ' / ' + 'Nationality',
                        ),
                        items: nationality.toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return nationality.toList();
                        },
                        onChanged: (value) {
                          //print(value);
                          setState(() {
                            prsNationalityController = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return null;
                        },
                      ),
                    ),
///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: TextFormField(
                        keyboardType: TextInputType.streetAddress,
                        autocorrect: false,
                        controller: prsHomeAddressController,
                        decoration: InputDecoration(
                          labelText: 'العنوان' + ' / ' + 'Home Address',
                          hintText: 'العنوان' + ' / ' + 'Home Address',
                        ),
                        maxLines: 3,
                        minLines: 2,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return null;
                        },
                      ),
                    ),
///////////////////////////////////////
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: DropdownButtonFormField(
                        value: prsCityController,
                        decoration: InputDecoration(
                          labelText: 'المدينة' + ' / ' + 'City',
                          hintText: 'المدينة' + ' / ' + 'City',
                        ),
                        items: city.toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return city.toList();
                        },
                        onChanged: (value) {
                          setState(() {
                            prsCityController = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return null;
                        },
                      ),
                    ),
///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textDirection: TextDirection.ltr,
                        autocorrect: false,
                        controller: prsPOBoxController,
                        decoration: InputDecoration(
                          labelText: 'صندوق البريد' + ' / ' + 'P.O. Box',
                          hintText: 'صندوق البريد' + ' / ' + 'P.O. Box',
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return null;
                        },
                      ),
                    ),
///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textDirection: TextDirection.ltr,
                        autocorrect: false,
                        controller: prsZipCodeController,
                        decoration: InputDecoration(
                          labelText: 'الرمز البريدي' + ' / ' + 'Zip Code',
                          hintText: 'الرمز البريدي' + ' / ' + 'Zip Code',
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return null;
                        },
                      ),
                    ),
///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection.ltr,
                        autocorrect: false,
                        controller: prsTelephoneController,
                        decoration: InputDecoration(
                          labelText: 'الهاتف' + ' / ' + 'Telephone No',
                          hintText: 'الهاتف' + ' / ' + 'Telephone No',
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return null;
                        },
                      ),
                    ),
///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: TextFormField(
                        autocorrect: false,
                        controller: prsEmailController,
                        keyboardType: TextInputType.emailAddress,
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني الشخصي' +
                              ' / ' +
                              'Personal E-mail',
                          hintText: 'البريد الإلكتروني الشخصي' +
                              ' / ' +
                              'Personal E-mail',
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return validateEmail(value, 1);
                        },
                      ),
                    ),
///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: TextFormField(
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        autocorrect: false,
                        controller: prsInstagramController,
                        decoration: InputDecoration(
                          labelText: 'إنستقرام' + ' / ' + 'Instagram',
                          hintText: 'إنستقرام' + ' / ' + 'Instagram',
                        ),
                      ),
                    ),
///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: TextFormField(
                        autocorrect: false,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        controller: prsTwitterController,
                        decoration: InputDecoration(
                          labelText: 'تويتر' + ' / ' + 'Twitter',
                          hintText: 'تويتر' + ' / ' + 'Twitter',
                        ),
                      ),
                    ),
///////////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      child: TextFormField(
                        autocorrect: false,
                        controller: prsHobbiesController,
                        decoration: InputDecoration(
                          labelText: 'الهوايات ولاهتمامات' +
                              ' / ' +
                              'Hobbies & Interests',
                          hintText: 'الهوايات ولاهتمامات' +
                              ' / ' +
                              'Hobbies & Interests',
                        ),
                        maxLines: 3,
                        minLines: 2,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'الحقل مطلوب / Required Field';
                          }
                          return null;
                        },
                      ),
                    ),
//////////////////////////////////

                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          child: Text(
                            'حفظ وارسال',
                          ),
                          color: masterBlue,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              handleUpdatePersonalData();
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
        ),
      ),
    );
  }
}
