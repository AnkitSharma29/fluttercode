import 'package:flutter/material.dart';
import 'package:mbo/classes/auth_by_email.dart';
import 'package:mbo/classes/input_validator.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';

class SignInAuth extends StatefulWidget {
  final EmailAuth auth;
  final VoidCallback getSignInStatus;
  final VoidCallback getSignUpForm;
  final VoidCallback getPasswordReminderForm;
  SignInAuth(
      {this.auth,
      this.getSignInStatus,
      this.getSignUpForm,
      this.getPasswordReminderForm,
      Key key})
      : super(key: key);

  @override
  _SignInAuthState createState() => _SignInAuthState();
}

class _SignInAuthState extends State<SignInAuth> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _autoValidate = AutovalidateMode.disabled;
  String _errorMasseges;

  final usrEmailController = TextEditingController();
  final usrPasswordController = TextEditingController();

  handleSignIn() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    String _usrEmail = usrEmailController.text;
    String _usrPassword = usrPasswordController.text;

    await widget.auth.signIn(_usrEmail, _usrPassword).then((theUser) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      widget.getSignInStatus();
    }).catchError((onError) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      _errorMasseges = '';
      switch (onError.code) {
        case 'user-not-found':
          _errorMasseges = "نرجو التأكد من البريد الإلكتروني المدخل";
          break;
        case 'wrong-password':
          _errorMasseges = "نرجو التأكد من صحة كلمة المرور المدخلة";
          break;
        case 'too-many-requests':
          _errorMasseges =
              "تم تقيد العملية بعد الفشل لعدة مرات. نرجو المحاولة لاحقا";
          break;
        default:
          _errorMasseges = onError.message;
      }
      Dialogs.alertDialog(context, _errorMasseges);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مجموعة المنارة المتكاملة',
          style: TextStyle(
            decoration: TextDecoration.none,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate,
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
                  'تسجيل الدخول',
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
                  style: TextStyle(fontFamily: englishFont),
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'اسم الدخول (البريد الإلكتروني)',
                    hintText: 'البريد الإلكتروني',
                    labelStyle: TextStyle(fontFamily: arabicFont),
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
                padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                child: TextFormField(
                  controller: usrPasswordController,
                  obscureText: true,
                  style: TextStyle(fontFamily: englishFont),
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'كلمة المرور',
                    hintText: 'كلمة المرور',
                    labelStyle: TextStyle(fontFamily: arabicFont),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    if (value.length < 6) {
                      return 'الحد الأدنى لكلمة المرور 6 حروف وأرقام';
                    }
                    if (value.length > 20) {
                      return 'الحد الأقصى لكلمة المرور 10 حروف وأرقام';
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
                      'تسجيل الدخول',
                    ),
                    textColor: Colors.white,
                    color: masterBlue,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        handleSignIn();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'نرجو التأكد من المعلومات المسجلة',
                              style: TextStyle(
                                color: Colors.white,
                              ),
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
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  child: RaisedButton(
                    color: bgGray,
                    child: Text(
                      'نسيت كلمة المرور ؟',
                    ),
                    textColor: masterBlue,
                    onPressed: () {
                      widget.getPasswordReminderForm();
                    },
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  child: RaisedButton(
                    child: Text(
                      'تسجيل جديد',
                    ),
                    textColor: Colors.white,
                    color: darkGreen,
                    onPressed: () {
                      widget.getSignUpForm();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
