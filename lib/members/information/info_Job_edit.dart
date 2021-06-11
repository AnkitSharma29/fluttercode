import 'package:flutter/material.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/classes/input_validator.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';

import '../../main.dart';

class InformationJobEditPage extends StatefulWidget {
  final MyUser currentUser;
  final VoidCallback getSignInStatus;
  InformationJobEditPage({this.currentUser, this.getSignInStatus, Key key})
      : super(key: key);

  @override
  _InformationJobEditPageState createState() => _InformationJobEditPageState();
}

class _InformationJobEditPageState extends State<InformationJobEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _autoValidate = AutovalidateMode.disabled;
  //String _errorMasseges;

  final jobCompanyNameController = TextEditingController();
  final jobTitleController = TextEditingController();
  final jobLocationController = TextEditingController();
  final jobMobileController = TextEditingController();
  final jobPOBoxController = TextEditingController();
  final jobZipController = TextEditingController();
  final jobTelephoneController = TextEditingController();
  final jobEmailController = TextEditingController();
  final jobPositionsController = TextEditingController();
  final jobMainBusinessController = TextEditingController();
  final jobWebsiteController = TextEditingController();
  final jobCompanyTelephoneController = TextEditingController();
  final jobAssistantController = TextEditingController();
  final jobCompanyEmailController = TextEditingController();

  String jobCityController;
  List<DropdownMenuItem<String>> city = [];
  Map mapCity = {};

  String jobCompanySectorController;
  List<DropdownMenuItem<String>> sector = [];
  Map mapSector = {};

  @override
  void initState() {
    super.initState();
    loadFormData();
    loadFormUserInformation();
  }

  loadFormUserInformation() {
    jobCompanyNameController.text = widget.currentUser.jobCompanyName;
    jobTitleController.text = widget.currentUser.jobTitle;
    jobLocationController.text = widget.currentUser.jobLocation;
    jobMobileController.text = widget.currentUser.jobMobile;
    jobPOBoxController.text = widget.currentUser.jobPOBox;
    jobZipController.text = widget.currentUser.jobZip;
    jobTelephoneController.text = widget.currentUser.jobTelephone;
    jobEmailController.text = widget.currentUser.jobEmail;
    jobPositionsController.text = widget.currentUser.jobPositions;
    jobMainBusinessController.text = widget.currentUser.jobMainBusiness;
    jobWebsiteController.text = widget.currentUser.jobWebsite;
    jobCompanyTelephoneController.text = widget.currentUser.jobCompanyTelephone;
    jobAssistantController.text = widget.currentUser.jobAssistant;
    jobCompanyEmailController.text = widget.currentUser.jobCompanyEmail;

    setState(() {
      jobCityController = widget.currentUser.jobCityId;
      jobCompanySectorController = widget.currentUser.jobCompanySectorId;
      // isLoading = false;
      // _curUsrMemDate = relativData.usrMemDate.toDate();
    });
  }

  loadFormData() async {
    //print('loadFormData loadFormData loadFormData');
    mapSector = {};
    sector = [];
    await lookUpSectorRef.get().then((doc) {
      doc.docs.forEach((doc) {
        mapSector[doc.id] = {
          'secId': doc.id,
          'secAr': doc.data()['secAr'],
          'secEn': doc.data()['secEn'],
        };
        sector.add(
          DropdownMenuItem(
            value: doc.id,
            child: Text(
              doc.data()['secAr'] + ' / ' + doc.data()['secEn'],
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      });
    }).whenComplete(() {
      setState(() {
        sector = sector;
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

  handleUpdateJobData() {
    //print('handleUpdateJobData handleUpdateJobData handleUpdateJobData');

    bool _jobStatus = true;
    String _jobCompanyName = jobCompanyNameController.text;
    String _jobTitle = jobTitleController.text;
    String _jobLocation = jobLocationController.text;
    String _jobMobile = jobMobileController.text;
    String _jobPOBox = jobPOBoxController.text;
    String _jobZip = jobZipController.text;
    String _jobTelephone = jobTelephoneController.text;
    String _jobEmail = jobEmailController.text;
    String _jobPositions = jobPositionsController.text;
    String _jobMainBusiness = jobMainBusinessController.text;
    String _jobWebsite = jobWebsiteController.text;
    String _jobCompanyTelephone = jobCompanyTelephoneController.text;
    String _jobAssistant = jobAssistantController.text;
    String _jobCompanyEmail = jobCompanyEmailController.text;

    String _jobCompanySectorId = mapSector[jobCompanySectorController]['secId'];
    String _jobCompanySectorNameAr =
        mapSector[jobCompanySectorController]['secAr'];
    String _jobCompanySectorNameEn =
        mapSector[jobCompanySectorController]['secEn'];

    String _jobCityId = mapCity[jobCityController]['ctyId'];
    String _jobCityNameAr = mapCity[jobCityController]['ctyAr'];
    String _jobCityNameEn = mapCity[jobCityController]['ctyEn'];

    Dialogs.showLoadingDialog(context, _keyLoader);
    usersRef.doc(widget.currentUser.usrId).update({
      'jobStatus': _jobStatus,
      'jobCompanyName': _jobCompanyName,
      'jobTitle': _jobTitle,
      'jobLocation': _jobLocation,
      'jobMobile': _jobMobile,
      'jobCityId': _jobCityId,
      'jobCityNameAr': _jobCityNameAr,
      'jobCityNameEn': _jobCityNameEn,
      'jobPOBox': _jobPOBox,
      'jobZip': _jobZip,
      'jobTelephone': _jobTelephone,
      'jobEmail': _jobEmail,
      'jobPositions': _jobPositions,
      'jobMainBusiness': _jobMainBusiness,
      'jobWebsite': _jobWebsite,
      'jobCompanyTelephone': _jobCompanyTelephone,
      'jobAssistant': _jobAssistant,
      'jobCompanyEmail': _jobCompanyEmail,
      'jobCompanySectorId': _jobCompanySectorId,
      'jobCompanySectorNameAr': _jobCompanySectorNameAr,
      'jobCompanySectorNameEn': _jobCompanySectorNameEn,
    }).then((onValue) async {
      Navigator.of(context, rootNavigator: true).pop();

      _formKey.currentState.reset();
      setState(() {
        jobCityController = null;
        jobCompanySectorController = null;
        _autoValidate = AutovalidateMode.disabled;
      });
      await Dialogs.alertDialog(
              context, 'لقد تم إعداد وحفظ معلومات العمل بنجاح')
          .then((val) {
        widget.getSignInStatus();
        Navigator.pop(context);
      });
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

                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                    child: TextFormField(
                      autocorrect: false,
                      controller: jobCompanyNameController,
                      decoration: InputDecoration(
                        labelText:
                            'اسم الشركة بالكامل' + ' / ' + 'Full Company Name',
                        hintText:
                            'اسم الشركة بالكامل' + ' / ' + 'Full Company Name',
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
                      controller: jobTitleController,
                      decoration: InputDecoration(
                        labelText: 'المنصب' + ' / ' + 'Job Title',
                        hintText: 'المنصب' + ' / ' + 'Job Title',
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
                      controller: jobLocationController,
                      decoration: InputDecoration(
                        labelText: 'موقع العمل' + ' / ' + 'Office Location',
                        hintText: 'موقع العمل' + ' / ' + 'Office Location',
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
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      controller: jobMobileController,
                      decoration: InputDecoration(
                        labelText: 'الجوال' + ' / ' + 'Mobile',
                        hintText: 'الجوال' + ' / ' + 'Mobile',
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
                    child: DropdownButtonFormField(
                      value: jobCityController,
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
                          jobCityController = value;
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
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      controller: jobPOBoxController,
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
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      controller: jobZipController,
                      decoration: InputDecoration(
                        labelText: 'الرمز البريدي' + ' / ' + 'Zip Code',
                        hintText: 'الرمز البريدي' + ' / ' + 'Zip Code',
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
                    child: TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      controller: jobTelephoneController,
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
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      controller: jobEmailController,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني' + ' / ' + 'E-Mail',
                        hintText: 'البريد الإلكتروني' + ' / ' + 'E-Mail',
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
                      controller: jobPositionsController,
                      decoration: InputDecoration(
                        labelText: 'المناصب' + ' / ' + 'Positions',
                        hintText: 'المناصب' + ' / ' + 'Positions',
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
                    child: TextFormField(
                      autocorrect: false,
                      controller: jobMainBusinessController,
                      decoration: InputDecoration(
                        labelText:
                            'النشاط التجاري الرئيسي' + ' / ' + 'Main Bussiness',
                        hintText:
                            'النشاط التجاري الرئيسي' + ' / ' + 'Main Bussiness',
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
                      keyboardType: TextInputType.url,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      controller: jobWebsiteController,
                      decoration: InputDecoration(
                        labelText:
                            'الموقع الإلكتروني' + ' / ' + 'Company Website',
                        hintText:
                            'الموقع الإلكتروني' + ' / ' + 'Company Website',
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
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      controller: jobCompanyTelephoneController,
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
                      controller: jobAssistantController,
                      decoration: InputDecoration(
                        labelText: 'اسم المساعد أومدير المكتب' +
                            ' / ' +
                            'Assistant or Secertary',
                        hintText: 'اسم المساعد أومدير المكتب' +
                            ' / ' +
                            'Assistant or Secertary',
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
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      controller: jobCompanyEmailController,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني' + ' / ' + 'E-mail',
                        hintText: 'البريد الإلكتروني' + ' / ' + 'E-mail',
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
                    child: DropdownButtonFormField(
                      value: jobCompanySectorController,
                      decoration: InputDecoration(
                        labelText: 'قطاع الشركة' + ' / ' + 'Company Sector',
                        hintText: 'قطاع الشركة' + ' / ' + 'Company Sector',
                      ),
                      items: sector.toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return sector.toList();
                      },
                      onChanged: (value) {
                        setState(() {
                          jobCompanySectorController = value;
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
////////////////////////////
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
                        color: darkGreen,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            handleUpdateJobData();
                          } else {
                            Scaffold.of(context).showSnackBar(
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
    );
  }
}
