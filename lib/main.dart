import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mbo/authentication/auth_password_reminder.dart';
import 'package:mbo/authentication/auth_sign_in.dart';
import 'package:mbo/authentication/auth_sign_up.dart';
import 'package:mbo/page_splash_screen.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/settings.dart';
import 'admin/admin_home_page.dart';
import 'classes/User.dart';
import 'classes/auth_by_email.dart';
import 'members/information/info_ahome_page.dart';
import 'members/mem_home_page.dart';
import 'members/payment/pay_packeges_page.dart';

final storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection('users');
final lookUpSalutationRef =
    FirebaseFirestore.instance.collection('lookUpSalutation');
final lookUpMaritalStatusRef =
    FirebaseFirestore.instance.collection('lookUpMaritalStatus');
final lookUpCountriesRef =
    FirebaseFirestore.instance.collection('lookUpCountries');
final lookUpCitiesRef = FirebaseFirestore.instance.collection('lookUpCities');
final lookUpSectorRef = FirebaseFirestore.instance.collection('lookUpSectors');
final lookUpSubscriptionsRef =
    FirebaseFirestore.instance.collection('lookUpSubscriptions');
final instantChattingRef =
    FirebaseFirestore.instance.collection('instantChatting');
final eventsRef = FirebaseFirestore.instance.collection('events');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MBO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        //primaryColor: Color.fromARGB(255, 11, 89, 141),

        visualDensity: VisualDensity.adaptivePlatformDensity,

        primaryColor: masterBlue,
        accentColor: masterBlue,
        backgroundColor: bgGray,
        fontFamily: 'GE',
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MyHomePage(auth: EmailAuth()),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final EmailAuthFunc auth;
  MyHomePage({this.auth, Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getSignInStatus();
  }

  MyUser currentUser;
  int currentUserType;
  Widget thePage = SplashScreenPage();

  getSignInStatus() async {
    //print('getSignInStatus');
    widget.auth.getCurrentUser().then((usr) async {
      if (usr != null) {
        //print(usr.uid);
        await getCurrentUserInfomation(usr.uid);
        //print(currentUser);
        if (currentUser != null) {
          int usrType = currentUser.usrType;
          int usrStatus = currentUser.usrStatus;

          switch (usrType) {
            // MEMBER USER
            case 1:
              switch (usrStatus) {
                // INFORMATION NOT COMPLETE
                case -2:
                // WAITING APPROVEL
                case -1:
                  setState(() {
                    thePage = InformationHomePage(
                      currentUser: currentUser,
                      doSignOut: handleSignOut,
                      getSignInStatus: getSignInStatus,
                    );
                  });
                  break;
                // PAYMENT NOT SET
                case 0:
                  setState(() {
                    thePage = PaymentPackegesPage(
                      currentUser: currentUser,
                      doSignOut: handleSignOut,
                      getSignInStatus: getSignInStatus,
                    );
                  });
                  break;
                // GOTO MEMBER EAREA
                case 1:
                  setState(() {
                    thePage = MemberHomePage(
                      currentUser: currentUser,
                      doSignOut: handleSignOut,
                      getSignInStatus: getSignInStatus,
                    );
                  });
                  break;
                default:
                  widget.auth.signOut();
                  Dialogs.alertDialog(context,
                      'حدث خلل في ملف المعلومات المسجل. نرجو التواصل مع إدارة التطبيق');
              }
              break;
            // ADMIN USER
            case 2:
              setState(() {
                thePage = AdminHomePage(
                  currentUser: currentUser,
                  auth: widget.auth,
                  doSignOut: handleSignOut,
                );
              });
              break;
            default:
              widget.auth.signOut();
              Dialogs.alertDialog(context,
                  'حدث خلل في ملف المعلومات المسجل. نرجو التواصل مع إدارة التطبيق');
          }
        } else {
          widget.auth.signOut();
          Dialogs.alertDialog(context,
              'حدث خلل في ملف المعلومات المسجل. نرجو التواصل مع إدارة التطبيق');
        }
      } else {
        setState(() {
          thePage = SignInAuth(
            auth: widget.auth,
            getSignInStatus: getSignInStatus,
            getSignUpForm: getSignUpForm,
            getPasswordReminderForm: getPasswordReminderForm,
          );
        });
      }
    });
  }

  getSignUpForm() {
    setState(() {
      thePage = SignUpAuth(
        auth: widget.auth,
        getSignInStatus: getSignInStatus,
      );
    });
  }

  getPasswordReminderForm() {
    setState(() {
      thePage = PasswordReminderAuth(
        auth: widget.auth,
        getSignUpForm: getSignUpForm,
        getSignInStatus: getSignInStatus,
      );
    });
  }

  handleSignOut() async {
    bool returnVal = await showSiginOutDilog();
    if (returnVal == true) {
      await usersRef.doc(currentUser.usrId).update({'usrOnline': false});
      widget.auth.signOut().then((value) {
        setState(() {
          thePage = SignInAuth(
            auth: widget.auth,
            getSignInStatus: getSignInStatus,
            getSignUpForm: getSignUpForm,
            getPasswordReminderForm: getPasswordReminderForm,
          );
        });
      });
    }
  }

  showSiginOutDilog() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here

          title: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('تنبيه'),
          ),
          content: Text(
            'هل أنت متأكد من تسجيل الخروج؟',
            textDirection: TextDirection.rtl,
          ),
          actions: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: FlatButton(
                child: Text("تراجع"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: FlatButton(
                color: masterBlue,
                child: Text("نعم"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  getCurrentUserInfomation(uid) async {
    await usersRef.doc(uid).get().then((DocumentSnapshot userInfo) {
      //print(userInfo.data().toString());
      currentUser = MyUser.fromDocument(userInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: thePage,
    );
  }
}
