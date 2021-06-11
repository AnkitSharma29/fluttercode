import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbo/classes/User.dart';
import 'package:mbo/wedgits/cashImages.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:image/image.dart' as theImg;
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';

class InformationExtEditPage extends StatefulWidget {
  final MyUser currentUser;
  final VoidCallback getSignInStatus;
  InformationExtEditPage({this.currentUser, this.getSignInStatus, Key key})
      : super(key: key);

  @override
  _InformationExtEditPageState createState() => _InformationExtEditPageState();
}

class _InformationExtEditPageState extends State<InformationExtEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _autoValidate = AutovalidateMode.disabled;
  //String _errorMasseges;

  File extComanyLogoImageFile;
  String extComanyLogoImageController;

  File extIdentityImageFile;
  String extIdentityImageController;

  String imgFileName;

  final extPromptedController = TextEditingController();
  final extMboMembersController = TextEditingController();
  bool extCommitmentController = false;

  @override
  void initState() {
    super.initState();
    loadFormUserInformation();
  }

  loadFormUserInformation() {
    extPromptedController.text = widget.currentUser.extPrompted;
    extMboMembersController.text = widget.currentUser.extMboMembers;
    extCommitmentController = widget.currentUser.extCommitment;

    setState(() {
      extComanyLogoImageController = widget.currentUser.extComanyLogoImage;
      extIdentityImageController = widget.currentUser.extIdentityImage;
      // isLoading = false;
      // _curUsrMemDate = relativData.usrMemDate.toDate();
    });
  }

  Future<String> uploadIamge(imageFile, imageName) async {
    // StorageUploadTask uploadTask =
    //     storageRef.child("members/$imageName.jpg").putFile(imageFile);
    // StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    // String downloadUrl = await storageSnap.ref.getDownloadURL();
    // return downloadUrl;
    UploadTask uploadTask =
        storageRef.child("members/mem_$imageName.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  compressLogoImage(imgFileName) async {
    final tmpDir = await getTemporaryDirectory();
    final path = tmpDir.path;
    theImg.Image imageFile =
        theImg.decodeImage(extComanyLogoImageFile.readAsBytesSync());

    final compressedImageFile = File('$path/img_$imgFileName.jpg')
      ..writeAsBytesSync(theImg.encodeJpg(imageFile, quality: 50));
    setState(() {
      extComanyLogoImageFile = compressedImageFile;
    });
  }

  compresIdentityImage(imgFileName) async {
    final tmpDir = await getTemporaryDirectory();
    final path = tmpDir.path;
    theImg.Image imageFile =
        theImg.decodeImage(extIdentityImageFile.readAsBytesSync());

    final compressedImageFile = File('$path/img_$imgFileName.jpg')
      ..writeAsBytesSync(theImg.encodeJpg(imageFile, quality: 50));
    setState(() {
      extIdentityImageFile = compressedImageFile;
    });
  }

  selectImage(parentContext, imgType) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            'إختر مصدر الصور',
            textAlign: TextAlign.center,
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: FlatButton.icon(
                color: Colors.brown[100],
                label: Text('من معرض الصور'),
                icon: Icon(Icons.photo_album),
                onPressed: () {
                  Navigator.pop(context);
                  handleChooseGallery(imgType);
                },
              ),
            ),
            SimpleDialogOption(
              child: FlatButton(
                color: Colors.brown[800],
                textColor: Colors.white,
                child: Text(
                  'إلغاء',
                  textAlign: TextAlign.left,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }

  handleChooseGallery(imgType) async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    setState(() {
      if (pickedFile != null) {
        if (imgType == 'Logo') {
          extComanyLogoImageFile = File(pickedFile.path);
        } else {
          extIdentityImageFile = File(pickedFile.path);
        }
      } else {
        if (imgType == 'Logo') {
          extComanyLogoImageFile = null;
        } else {
          extIdentityImageFile = null;
        }
      }
    });
  }

  handleUpdateExtraData() async {
    //print('handleUpdateExtraData handleUpdateExtraData handleUpdateExtraData');
    if (!extCommitmentController) return;
    if (extComanyLogoImageController == null &&
        extComanyLogoImageFile == null) {
      return;
    }
    if (extIdentityImageController == null && extIdentityImageFile == null) {
      return;
    }
    bool _extStatus = true;

    String _extPrompted = extPromptedController.text;
    String _extMboMembers = extMboMembersController.text;
    bool _extCommitment = extCommitmentController;
    Dialogs.showLoadingDialog(context, _keyLoader);

    imgFileName = null;
    if (extComanyLogoImageFile != null) {
      imgFileName = 'Logo_' + Uuid().v4();
      await compressLogoImage(imgFileName);
      extComanyLogoImageController =
          await uploadIamge(extComanyLogoImageFile, imgFileName);
    }
    imgFileName = null;
    if (extIdentityImageFile != null) {
      imgFileName = 'Identity_' + Uuid().v4();
      await compresIdentityImage(imgFileName);
      extIdentityImageController =
          await uploadIamge(extIdentityImageFile, imgFileName);
    }

    String _extComanyLogoImage = extComanyLogoImageController;
    String _extIdentityImage = extIdentityImageController;

    usersRef.doc(widget.currentUser.usrId).update({
      'extStatus': _extStatus,
      'extPrompted': _extPrompted,
      'extMboMembers': _extMboMembers,
      'extCommitment': _extCommitment,
      'extComanyLogoImage': _extComanyLogoImage,
      'extIdentityImage': _extIdentityImage,
    }).then((onValue) async {
      Navigator.of(context, rootNavigator: true).pop();

      _formKey.currentState.reset();
      setState(() {
        _autoValidate = AutovalidateMode.disabled;
      });
      await Dialogs.alertDialog(
              context, 'لقد تم إعداد وحفظ المعلومات الإضافية بنجاح')
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
                          'الخطوة الرابعة' + ' : ' + 'تفاصيل إضافية ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Fourth Step : Additional details',
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
                  SizedBox(
                    width: double.infinity,
                    child: MasterLabel(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'شعار الشركة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Company Logo',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: englishFont,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      theColor: darkGreen,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: bgGray,
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            width: 120.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/no-logo.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Stack(
                              children: <Widget>[
                                (extComanyLogoImageController != null)
                                    ? myCachedNetworkImage(
                                        extComanyLogoImageController,
                                        myBorderRadius: 75.0)
                                    : Container(
                                        width: 0.0,
                                        height: 0.0,
                                      ),
                                (extComanyLogoImageFile != null)
                                    ? Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: FileImage(
                                                extComanyLogoImageFile),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 0.0,
                                        height: 0.0,
                                      ),
                                Center(
                                  child: (extComanyLogoImageController !=
                                              null &&
                                          extComanyLogoImageFile == null)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            IconButton(
                                              color: Colors.white,
                                              icon: Icon(
                                                  Icons.remove_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  extComanyLogoImageController =
                                                      null;
                                                });
                                              },
                                            ),
                                            IconButton(
                                              color: Colors.white,
                                              icon: Icon(
                                                  Icons.add_photo_alternate),
                                              onPressed: () {
                                                selectImage(context, 'Logo');
                                              },
                                            ),
                                          ],
                                        )
                                      : (extComanyLogoImageFile == null)
                                          ? IconButton(
                                              color: Colors.white,
                                              icon: Icon(Icons.add_a_photo),
                                              onPressed: () {
                                                selectImage(context, 'Logo');
                                              },
                                            )
                                          : IconButton(
                                              color: Colors.white,
                                              icon: Icon(
                                                  Icons.remove_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  extComanyLogoImageFile = null;
                                                });
                                              },
                                            ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            (extComanyLogoImageController == null &&
                                    extComanyLogoImageFile == null)
                                ? 'يجب إرفاق صورة'
                                : '',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),

///////////////////////////////////////

                  SizedBox(
                    width: double.infinity,
                    child: MasterLabel(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'صورة الهوية',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Idintity Photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: englishFont,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      theColor: darkGreen,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: bgGray,
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            width: 120.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/no-logo.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Stack(
                              children: <Widget>[
                                (extIdentityImageController != null)
                                    ? myCachedNetworkImage(
                                        extIdentityImageController,
                                        myBorderRadius: 75.0)
                                    : Container(
                                        width: 0.0,
                                        height: 0.0,
                                      ),
                                (extIdentityImageFile != null)
                                    ? Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image:
                                                FileImage(extIdentityImageFile),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 0.0,
                                        height: 0.0,
                                      ),
                                Center(
                                  child: (extIdentityImageController != null &&
                                          extIdentityImageFile == null)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            IconButton(
                                              color: Colors.white,
                                              icon: Icon(
                                                  Icons.remove_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  extIdentityImageController =
                                                      null;
                                                });
                                              },
                                            ),
                                            IconButton(
                                              color: Colors.white,
                                              icon: Icon(
                                                  Icons.add_photo_alternate),
                                              onPressed: () {
                                                selectImage(
                                                    context, 'Identity');
                                              },
                                            ),
                                          ],
                                        )
                                      : (extIdentityImageFile == null)
                                          ? IconButton(
                                              color: Colors.white,
                                              icon: Icon(Icons.add_a_photo),
                                              onPressed: () {
                                                selectImage(
                                                    context, 'Identity');
                                              },
                                            )
                                          : IconButton(
                                              color: Colors.white,
                                              icon: Icon(
                                                  Icons.remove_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  extIdentityImageFile = null;
                                                });
                                              },
                                            ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            (extIdentityImageController == null &&
                                    extIdentityImageFile == null)
                                ? 'يجب إرفاق صورة'
                                : '',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),

///////////////////////////////////////
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                    child: TextFormField(
                      autocorrect: false,
                      controller: extPromptedController,
                      decoration: InputDecoration(
                        labelText: 'دافعك للحصول على العضوية' +
                            ' / ' +
                            'Your prompted for MBO membership',
                        hintText: 'دافعك للحصول على العضوية' +
                            ' / ' +
                            'Your prompted for MBO membership',
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
                      controller: extMboMembersController,
                      decoration: InputDecoration(
                        labelText: 'اسم معرفين من الأعضاء' +
                            ' / ' +
                            'Named Two MBO Members',
                        hintText: 'اسم معرفين من الأعضاء' +
                            ' / ' +
                            'Named Two MBO Members',
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
                  SizedBox(
                    width: double.infinity,
                    child: MasterLabel(
                      content: Text(
                        'أتعهد بالأنظمة واللوائح الداخلية للمجموعة، وأن أمارس حقي كعضو فيها وفق ما هو متعارف عليه من عضو في مجموعات مشابهة. كما أتعهد بعدم نشر آراء المجموعة أو أعضائها إلا بعد الحصول على الموافقة المكتوبة المسبقة من مجلس إدارة المجموعة.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      theColor: darkGreen,
                    ),
                  ),

                  CheckboxListTile(
                    value: extCommitmentController,
                    onChanged: (val) {
                      if (extCommitmentController == false) {
                        setState(() {
                          extCommitmentController = true;
                        });
                      } else if (extCommitmentController == true) {
                        setState(() {
                          extCommitmentController = false;
                        });
                      }
                    },
                    subtitle: !extCommitmentController
                        ? Text(
                            'Required / مطلوب',
                            style: TextStyle(color: Colors.red),
                          )
                        : null,
                    title: new Text(
                      'موافق',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.green,
                  ),

/////////////////////////////
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
                            handleUpdateExtraData();
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
