import 'package:flutter/material.dart';
import 'package:mbo/main.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/settings.dart';

class SubscriptionsAddPage extends StatefulWidget {
  SubscriptionsAddPage({Key key}) : super(key: key);

  @override
  _SubscriptionsAddPageState createState() => _SubscriptionsAddPageState();
}

class _SubscriptionsAddPageState extends State<SubscriptionsAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _autoValidate = AutovalidateMode.disabled;
  String _errorMasseges;

  final subArController = TextEditingController();
  final subEnController = TextEditingController();
  final subDaysController = TextEditingController();
  final subAmountController = TextEditingController();

  handleSave() {
    Dialogs.showLoadingDialog(context, _keyLoader);

    bool _subStatus = true;

    String _subAr = subArController.text;
    String _subEn = subEnController.text;
    String _subDays = subDaysController.text;
    String _subAmount = subAmountController.text;

    lookUpSubscriptionsRef.doc().set({
      'subAr': _subAr,
      'subEn': _subEn,
      'subDays': _subDays,
      'subAmount': _subAmount,
      'subStatus': _subStatus,
    }).then((value) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Dialogs.alertDialog(context, 'لقد تم حفظ المعلومات بنجاح');
      _formKey.currentState.reset();
      subArController.clear();
      subEnController.clear();
      subDaysController.clear();
      subAmountController.clear();
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
        title: Text('إضافة مدد الإشتراكات'),
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
                      controller: subArController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'مدة الإشتراك باللغة العربية',
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
                      controller: subEnController,
                      decoration: InputDecoration(
                        labelText: 'مدة الإشتراك باللغة الإنجليزية',
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
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      controller: subDaysController,
                      decoration: InputDecoration(
                        labelText: 'مدة الإشتراك بالأيام',
                        hintText: 'مدة الإشتراك بالأيام',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }
                        if (int.parse(value.toString()) < 0) {
                          return 'نرجو التأكد من مدة الإشتراك';
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      controller: subAmountController,
                      decoration: InputDecoration(
                        labelText: 'مبلغ الإشتراك',
                        hintText: 'مبلغ الإشتراك',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }
                        if (int.parse(value.toString()) < 0) {
                          return 'نرجو التأكد من مبلغ الإشتراك';
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
