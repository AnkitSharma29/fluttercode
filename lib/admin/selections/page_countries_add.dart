import 'package:flutter/material.dart';
import 'package:mbo/main.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/settings.dart';

class CountriesAddPage extends StatefulWidget {
  CountriesAddPage({Key key}) : super(key: key);

  @override
  _CountriesAddPageState createState() => _CountriesAddPageState();
}

class _CountriesAddPageState extends State<CountriesAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _autoValidate = AutovalidateMode.disabled;
  String _errorMasseges;

  final cntArController = TextEditingController();
  final cntEnController = TextEditingController();

  handleSave() {
    Dialogs.showLoadingDialog(context, _keyLoader);

    bool _cntStatus = true;

    String _cntAr = cntArController.text;
    String _cntEn = cntEnController.text;
    lookUpCountriesRef.doc().set({
      'cntAr': _cntAr,
      'cntEn': _cntEn,
      'cntStatus': _cntStatus,
    }).then((value) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Dialogs.alertDialog(context, 'لقد تم حفظ المعلومات بنجاح');
      _formKey.currentState.reset();
      cntArController.clear();
      cntEnController.clear();
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
        title: Text('إضافة جنسية'),
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
                      controller: cntArController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'الجنسية باللغة العربية',
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
                      controller: cntEnController,
                      decoration: InputDecoration(
                        labelText: 'الجنسية باللغة الإنجليزية',
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
