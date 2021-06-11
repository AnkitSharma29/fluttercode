import 'package:flutter/material.dart';
import 'package:mbo/main.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/settings.dart';

class SectorsAddPage extends StatefulWidget {
  SectorsAddPage({Key key}) : super(key: key);

  @override
  _SectorsAddPageState createState() => _SectorsAddPageState();
}

class _SectorsAddPageState extends State<SectorsAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _autoValidate = AutovalidateMode.disabled;
  String _errorMasseges;

  final secArController = TextEditingController();
  final secEnController = TextEditingController();

  handleSave() {
    Dialogs.showLoadingDialog(context, _keyLoader);

    bool _secStatus = true;

    String _secAr = secArController.text;
    String _secEn = secEnController.text;
    lookUpSectorRef.doc().set({
      'secAr': _secAr,
      'secEn': _secEn,
      'secStatus': _secStatus,
    }).then((value) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Dialogs.alertDialog(context, 'لقد تم حفظ المعلومات بنجاح');
      _formKey.currentState.reset();
      secArController.clear();
      secEnController.clear();
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
        title: Text('إضافة تصنيف تجاري'),
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
                      controller: secArController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'التصنيف باللغة العربية',
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
                      controller: secEnController,
                      decoration: InputDecoration(
                        labelText: 'التصنيف باللغة الإنجليزية',
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
