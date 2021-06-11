import 'package:flutter/material.dart';
import 'package:mbo/main.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/settings.dart';

class CitiesAddPage extends StatefulWidget {
  CitiesAddPage({Key key}) : super(key: key);

  @override
  _CitiesAddPageState createState() => _CitiesAddPageState();
}

class _CitiesAddPageState extends State<CitiesAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _autoValidate = AutovalidateMode.disabled;
  String _errorMasseges;

  final ctyArController = TextEditingController();
  final ctyEnController = TextEditingController();

  handleSave() {
    Dialogs.showLoadingDialog(context, _keyLoader);

    bool _ctyStatus = true;

    String _ctyAr = ctyArController.text;
    String _ctyEn = ctyEnController.text;
    lookUpCitiesRef.doc().set({
      'ctyAr': _ctyAr,
      'ctyEn': _ctyEn,
      'ctyStatus': _ctyStatus,
    }).then((value) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Dialogs.alertDialog(context, 'لقد تم حفظ المعلومات بنجاح');
      _formKey.currentState.reset();
      ctyArController.clear();
      ctyEnController.clear();
    }).catchError((onError) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      _errorMasseges = 'حدث خلل أثناء إجراء العملية. نرجو المحاولة مرة أخرى';
      if (_errorMasseges.isNotEmpty) {
        Dialogs.alertDialog(context, _errorMasseges);
      }
    }).whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة مدينة'),
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
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                    child: TextFormField(
                      controller: ctyArController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'اسم المدينة باللغة العربية',
                        hintText: 'العربية',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                    child: TextFormField(
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      controller: ctyEnController,
                      decoration: InputDecoration(
                        labelText: 'اسم المدينة باللغة الإنجليزية',
                        hintText: 'English',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }
                        return null;
                      },
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
                        child: Text(
                          'حفظ المعلومات',
                        ),
                        textColor: Colors.white,
                        color: masterBlue,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            handleSave();
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
    );
  }
}
