import 'package:flutter/material.dart';
import 'package:mbo/classes/auth_by_email.dart';
import 'package:mbo/classes/input_validator.dart';
import 'package:mbo/wedgits/dialogs.dart';

class PublicHomePage extends StatefulWidget {
  final EmailAuth auth;
  final VoidCallback getSignInStatus;
  final VoidCallback getSignUp;
  PublicHomePage({this.auth, this.getSignInStatus, this.getSignUp, Key key})
      : super(key: key);

  @override
  _PublicHomePageState createState() => _PublicHomePageState();
}

class _PublicHomePageState extends State<PublicHomePage> {
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
        title: Text('XXXمجموعة المنارة المتكاملة'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate,
          child: Padding(
            padding: EdgeInsets.all(
              20.0,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: Color.fromARGB(255, 11, 89, 141),
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'معلومات تسجيل الدخول',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                TextFormField(
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
                TextFormField(
                  controller: usrPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'كلمة المرور',
                    hintText: 'كلمة المرور',
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
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton.icon(
                    textColor: Colors.white,
                    label: Text(
                      'تسجيل الدخول',
                    ),
                    icon: Icon(
                      Icons.input,
                    ),
                    color: Color.fromARGB(255, 11, 89, 141),
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
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text(
                      'نسيت كلمة المرور ؟',
                    ),
                    textColor: Colors.blue,
                    //color: Colors.orange,
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PasswordReminderAuth(
                      //       auth: widget.auth,
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text(
                      'تسجيل جديد',
                    ),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      widget.getSignUp();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => SignUpPage(
                      //       auth: widget.auth,
                      //       getSignInStatus: widget.getSignInStatus,
                      //     ),
                      //   ),
                      // );
                    },
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
