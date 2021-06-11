import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/wedgits/cashImages.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';

class ProfileEditPage extends StatefulWidget {
  final MyUser currentUser;
  final VoidCallback getSignInStatus;
  ProfileEditPage({this.currentUser, this.getSignInStatus, Key key})
      : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _autoValidate = AutovalidateMode.disabled;

  //String _errorMasseges;

  File usrImgFile;
  String usrImgController;

  String usrSalutationController;
  List<DropdownMenuItem<String>> salutation = [];
  Map mapSalutation = {};

  final usrNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadFormData();
    loadFormUserInformation();
  }

  loadFormUserInformation() {
    usrImgController = widget.currentUser.usrImage;
    usrNameController.text = widget.currentUser.usrName;
    setState(() {
      usrSalutationController = widget.currentUser.usrSalutationId;
    });
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
        //chtImageController = File(pickedFile.path);
        usrImgFile = File(pickedFile.path);
      } else {
        usrImgFile = null;
      }
    });
  }

  Future<String> handelUploadIamge(imageFile, imageName) async {
    UploadTask uploadTask =
        storageRef.child("members/mem_$imageName.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  handleUpdateUserInformation() async {
    String _usrNameController = usrNameController.text;

    String _usrSalutationId = mapSalutation[usrSalutationController]['slutId'];
    String _usrSalutationAr = mapSalutation[usrSalutationController]['slutAr'];
    String _usrSalutationEn = mapSalutation[usrSalutationController]['slutEn'];
    String _usrImage;
    Dialogs.showLoadingDialog(context, _keyLoader);

    if (usrImgFile != null) {
      String imgFileName = Uuid().v4();
      _usrImage = await handelUploadIamge(usrImgFile, imgFileName);
    } else {
      _usrImage = usrImgController;
    }

    usersRef.doc(widget.currentUser.usrId).update({
      'usrName': _usrNameController,
      'usrSalutationId': _usrSalutationId,
      'usrSalutationAr': _usrSalutationAr,
      'usrSalutationEn': _usrSalutationEn,
      'usrImage': _usrImage,
    }).then((onValue) async {
      Navigator.of(context, rootNavigator: true).pop();

      _formKey.currentState.reset();
      setState(() {
        usrSalutationController = null;
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
      appBar: new AppBar(
        centerTitle: true,
        title: Text('الملف الشخصي'),
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
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          (usrImgController != null)
                              ? Container(
                                  width: 175.0,
                                  height: 175.0,
                                  child: myCachedNetworkImage(usrImgController,
                                      myBorderRadius: 150.0),
                                )
                              : Container(
                                  width: 175.0,
                                  height: 175.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/no-photo.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                          (usrImgFile != null)
                              ? Container(
                                  width: 175.0,
                                  height: 175.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: FileImage(usrImgFile),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 0.0,
                                  height: 0.0,
                                ),
                          Center(
                            child: (usrImgController != null &&
                                    usrImgFile == null)
                                ? IconButton(
                                    color: Colors.white,
                                    icon: Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      setState(() {
                                        usrImgController = null;
                                      });
                                    },
                                  )
                                : (usrImgFile == null)
                                    ? IconButton(
                                        color: Colors.white,
                                        icon: Icon(
                                          Icons.add_photo_alternate,
                                          color: Colors.orange,
                                        ),
                                        onPressed: () {
                                          handleChooseGallery();
                                        },
                                      )
                                    : IconButton(
                                        color: Colors.white,
                                        icon: Icon(Icons.remove_circle_outline),
                                        onPressed: () {
                                          setState(() {
                                            usrImgFile = null;
                                          });
                                        },
                                      ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                          'تعديل الملف الشخصي',
                        ),
                        color: darkGreen,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            handleUpdateUserInformation();
                          } else {
                            Scaffold.of(contextx).showSnackBar(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
