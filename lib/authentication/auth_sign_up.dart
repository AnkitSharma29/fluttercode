import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbo/classes/auth_by_email.dart';
import 'package:mbo/classes/input_validator.dart';
import 'package:mbo/main.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';
import 'package:uuid/uuid.dart';

class SignUpAuth extends StatefulWidget {
  final EmailAuthFunc auth;
  final VoidCallback getSignInStatus;

  SignUpAuth({this.auth, this.getSignInStatus, Key key}) : super(key: key);

  @override
  _SignUpAuthState createState() => _SignUpAuthState();
}

class Item {
  const Item(this.name);
  final String name;
}

class _SignUpAuthState extends State<SignUpAuth> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _autoValidate = AutovalidateMode.disabled;
  String _errorMasseges;

  File usrImgController;

  String usrSalutationController;
  List<DropdownMenuItem<String>> salutation = [];
  Map mapSalutation = {};

  final usrNameController = TextEditingController();
  final usrEmailController = TextEditingController();
  final usrPasswordController = TextEditingController();
  final usrRePasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadFormData();
  }

  loadFormData() async {
    mapSalutation = {};
    salutation = [];
    await lookUpSalutationRef.get().then((doc) {
      doc.docs.forEach((doc) {
        mapSalutation[doc.id] = {
          'slutId': doc.id,
          'slutAr': doc.data()['slutAr'],
          'slutEn': doc.data()['slutEn'],
        };
        salutation.add(
          DropdownMenuItem(
            value: doc.id,
            child: Text(
              doc.data()['slutAr'] + ' / ' + doc.data()['slutEn'],
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      });
    }).whenComplete(() {
      setState(() {
        salutation = salutation;
      });
    });
  }

  handleChooseGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    setState(() {
      if (pickedFile != null) {
        usrImgController = File(pickedFile.path);
      } else {
        usrImgController = null;
      }
    });
  }

  Future<String> handelUploadIamge(imageFile, imageName) async {
    UploadTask uploadTask =
        storageRef.child("members/mem_$imageName.jpg").putFile(imageFile);

    // StorageUploadTask uploadTask =
    //     storageRef.child("members/mem_$imageName.jpg").putFile(imageFile);

    TaskSnapshot storageSnap = await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  handleSignUp() async {
    //print('handleSignUp handleSignUp handleSignUp');
    Dialogs.showLoadingDialog(context, _keyLoader);
    String _usrImage;
    if (usrImgController != null) {
      String imgFileName = Uuid().v4();
      _usrImage = await handelUploadIamge(usrImgController, imgFileName);
    } else {
      _usrImage = null;
    }

    int _usrStatus = -2;
    int _usrType = 1;
    String _usrName = usrNameController.text;
    String _usrEmail = usrEmailController.text;
    String _usrPassword = usrPasswordController.text;
    //String _usrSalutation = usrSalutationController.name;

    String _usrSalutationId = mapSalutation[usrSalutationController]['slutId'];
    String _usrSalutationAr = mapSalutation[usrSalutationController]['slutAr'];
    String _usrSalutationEn = mapSalutation[usrSalutationController]['slutEn'];

    DateTime _usrDateTime = DateTime.now();

    widget.auth.signUp(_usrEmail, _usrPassword).then((usrId) {
      usersRef.doc(usrId).set({
        'usrId': usrId,
        'usrName': _usrName,
        'usrEmail': _usrEmail,
        'usrPassword': _usrPassword,
        'usrType': _usrType,
        'usrStatus': _usrStatus,
        'usrDateTime': _usrDateTime,
        'usrSalutationId': _usrSalutationId,
        'usrSalutationAr': _usrSalutationAr,
        'usrSalutationEn': _usrSalutationEn,
        'usrImage': _usrImage,
      });
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Dialogs.alertDialog(context,
          'لقد تم إنشاء حسابكم بنجاح. يمكنكم متابعة تسجيل بياناتكم الآن.');
      _formKey.currentState.reset();
      usrEmailController.clear();
      usrPasswordController.clear();
      usrRePasswordController.clear();
      usrNameController.clear();
      _usrDateTime = null;
      setState(() {
        _usrImage = null;
      });
      //Navigator.of(context).pop();
      widget.getSignInStatus();
    }).catchError((onError) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      //print(onError.code);
      if (onError.code == "email-already-in-use") {
        _errorMasseges =
            'الإيميل المدخل مستخدم سابقا. اذا نسيت كلمة المرور يمكن إستردادها. أو يمكنك إنشاء حساب باستخدام بريد إلكتروني أخر';
      } else {
        _errorMasseges = 'حدث خلل أثناء التسجيل نرجو المحاولة مرة أخرى';
      }
      if (_errorMasseges.isNotEmpty) {
        Dialogs.alertDialog(context, _errorMasseges);
      }
    }).whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مجموعة المنارة المتكاملة'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => widget.getSignInStatus(),
        ),
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
                  padding: EdgeInsets.all(1.0),
                ),
                MasterLabel(
                  theColor: masterBlue,
                  content: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'تسجيل جديد',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'New Registartion',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          ),
                        ],
                      ),
                      Divider(),
                      Text(
                        'الخطوة الأولى' + ' : ' + ' إنشاء حساب ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                      ),
                      Text(
                        'First Step : Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: englishFont,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: Card(
                //     color: Color.fromARGB(255, 11, 89, 141),
                //     child: Padding(
                //       padding: EdgeInsets.all(15.0),
                //       child: Column(
                //         children: [
                //           Text(
                //             'تسجيل جديد',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 18.0,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //           Text(
                //             'الخطوة الأولى' + ' : ' + ' إنشاء حساب ',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 12.0,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //           Text(
                //             'First Step : Create Account',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 12.0,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.all(1.0),
                ),
                MasterLabel(
                  theColor: darkGreen,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'الصورة الشخصية',
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                      Text(
                        'Personal Photo',
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: Card(
                //     color: Colors.blue,
                //     child: Padding(
                //       padding: EdgeInsets.all(10.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           Text(
                //             'الصورة الشخصية',
                //             style:
                //                 TextStyle(color: Colors.white, fontSize: 14.0),
                //           ),
                //           Text(
                //             'Personal Photo',
                //             style:
                //                 TextStyle(color: Colors.white, fontSize: 14.0),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(bottom: 15.0),
                // ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 65.0,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: (usrImgController == null)
                          ? AssetImage('assets/images/no-photo.png')
                          : FileImage(usrImgController),
                      child: IconButton(
                        icon: (usrImgController == null)
                            ? Icon(Icons.add)
                            : Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          //print('Logo Add');
                          if (usrImgController == null) {
                            handleChooseGallery();
                          } else {
                            setState(() {
                              usrImgController = null;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(bottom: 15.0),
                // ),
                MasterLabel(
                  theColor: darkGreen,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'اللقب/الاسم',
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                      Text(
                        'Salutation/Name',
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),

                // SizedBox(
                //   width: double.infinity,
                //   child: Card(
                //     color: Colors.blue,
                //     child: Padding(
                //         padding: EdgeInsets.all(10.0),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //           children: [
                //             Text(
                //               'اللقب/الاسم',
                //               style: TextStyle(
                //                   color: Colors.white, fontSize: 14.0),
                //             ),
                //             Text(
                //               'Salutation/Name',
                //               style: TextStyle(
                //                   color: Colors.white, fontSize: 14.0),
                //             ),
                //           ],
                //         )),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(bottom: 15.0),
                // ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                  child: DropdownButtonFormField(
                    value: usrSalutationController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.streetview),
                      labelText: 'Salutation/اللقب',
                    ),

                    items: salutation.toList(),
                    selectedItemBuilder: (BuildContext context) {
                      return salutation.toList();
                    },
                    onChanged: (value) {
                      setState(() {
                        usrSalutationController = value;
                      });
                    },
                    // items: salutation.map((Item unit) {
                    //   return DropdownMenuItem<Item>(
                    //     value: unit,
                    //     child: Text(
                    //       unit.name,
                    //       style: TextStyle(
                    //         color: Colors.black,
                    //       ),
                    //       textAlign: TextAlign.right,
                    //     ),
                    //   );
                    // }).toList(),
                    // onChanged: (value) {
                    //   setState(() {
                    //     usrSalutationController = value;
                    //   });
                    // },
                    validator: (value) {
                      if (value == null) {
                        return 'الحقل مطلوب / Required Field';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                  child: TextFormField(
                    autocorrect: false,
                    controller: usrNameController,
                    decoration: InputDecoration(
                      hintText: 'الاسم / Name',
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'الحقل مطلوب / Required Field';
                      }
                      return null;
                    },
                  ),
                ),

                // Padding(
                //   padding: EdgeInsets.only(bottom: 15.0),
                // ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 2.0),
                ),
                MasterLabel(
                  theColor: darkGreen,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'البريد الإلكتروني / كلمة المرور',
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                      Text(
                        'Email/Password',
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),

                // SizedBox(
                //   width: double.infinity,
                //   child: Card(
                //     color: Colors.blue,
                //     child: Padding(
                //       padding: EdgeInsets.all(10.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           Text(
                //             'البريد الإلكتروني / كلمة المرور',
                //             style:
                //                 TextStyle(color: Colors.white, fontSize: 14.0),
                //           ),
                //           Text(
                //             'Email/Password',
                //             style:
                //                 TextStyle(color: Colors.white, fontSize: 14.0),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                  child: TextFormField(
                    controller: usrEmailController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: 'البريد الإلكتروني/ Email',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'الحقل مطلوب / Required Field';
                      }
                      return validateEmail(value, 1);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                  child: TextFormField(
                    controller: usrPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      hintText: 'كلمة المرور / Password',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'الحقل مطلوب / Required Field';
                      }
                      if (value.length < 6) {
                        return 'الحد الأدنى 6 حروف وأرقام / Min 6 Chars and Numbers';
                      }
                      if (value.length > 10) {
                        return 'الحد الأقصى 10 حروف وأرقام / Max 10 Chars and Numbers';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                  child: TextFormField(
                    controller: usrRePasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock_outline),
                      hintText: 'إعادة كلمة المرور / Re-Password',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'الحقل مطلوب / Required Field';
                      }
                      if (value.length < 6) {
                        return 'الحد الأدنى 6 حروف وأرقام / Min 6 Chars and Numbers';
                      }
                      if (value.length > 10) {
                        return 'الحد الأقصى 10 حروف وأرقام / Max 10 Chars and Numbers';
                      }
                      if (value != usrPasswordController.text) {
                        return 'كلمة المرور غير متطابقة / Password does not match';
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
                      textColor: Colors.white,
                      child: Text(
                        'إنشاء الحساب',
                      ),
                      color: masterBlue,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          handleSignUp();
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
