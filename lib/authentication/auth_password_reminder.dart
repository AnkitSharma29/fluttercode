import 'package:flutter/material.dart';
import 'package:mbo/classes/auth_by_email.dart';
import 'package:mbo/classes/input_validator.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';

class PasswordReminderAuth extends StatefulWidget {
  final EmailAuthFunc auth;
  final VoidCallback getSignUpForm;
  final VoidCallback getSignInStatus;
  PasswordReminderAuth(
      {this.auth, this.getSignUpForm, this.getSignInStatus, Key key})
      : super(key: key);

  @override
  _PasswordReminderAuthState createState() => _PasswordReminderAuthState();
}

class _PasswordReminderAuthState extends State<PasswordReminderAuth> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  //bool _autoValidate = false;
  var _autoValidate = AutovalidateMode.disabled;
  String _errorMasseges;

  final usrEmailController = TextEditingController();

  handleResetPassword() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    String _usrEmail = usrEmailController.text;
    widget.auth.resetPassword(_usrEmail).then((value) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Dialogs.alertDialog(
          context, 'لقد تم إرسال رابط تغير كلمة المرور على بريدكم الإلكتروني');
      usrEmailController.clear();
    }).catchError((onError) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      _errorMasseges = '';
      switch (onError.code) {
        case 'user-not-found':
          _errorMasseges = "نرجو التأكد من البريد الإلكتروني المدخل";
          break;
        case 'too-many-requests':
          _errorMasseges =
              "تم تقيد العملية بعد الفشل لعدة مرات. نرجو المحاولة لاحقا";
          break;
        default:
          _errorMasseges = onError.message;
      }
      //msgDialog(_errorMasseges);
      Dialogs.alertDialog(context, _errorMasseges);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مجموعة المنارة المتكاملة'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => widget.getSignInStatus(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 65.0,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
                MasterLabel(
                  theColor: darkGreen,
                  content: Text(
                    'إعادة تعيين كلمة المرور',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                  child: TextFormField(
                    controller: usrEmailController,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'اسم الدخول (البريد الإلكتروني)',
                      hintText: 'البريد الإلكتروني',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'هذا الحقل مطلوب';
                      }
                      return validateEmail(value, 0);
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
                      textColor: Colors.white,
                      child: Text(
                        'إعادة تعيين كلمة المرور',
                      ),
                      color: masterBlue,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          handleResetPassword();
                        } else {
                          setState(() {
                            _autoValidate = AutovalidateMode.always;
                          });
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                    child: RaisedButton.icon(
                      textColor: masterBlue,
                      label: Text(
                        'العودة لتسجيل الدخول',
                      ),
                      icon: Icon(
                        Icons.get_app,
                      ),
                      color: bgGray,
                      onPressed: () {
                        widget.getSignInStatus();
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
