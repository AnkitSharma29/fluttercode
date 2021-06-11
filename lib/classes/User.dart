import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String usrEmail;
  final String usrId;
  final String usrName;
  final int usrStatus;
  final int usrType;
  final String usrImage;
  final Timestamp usrDateTime;

  final String usrSalutationId;
  final String usrSalutationAr;
  final String usrSalutationEn;
  final bool usrOnline;

  final bool prsStatus;
  final String prsFirstName;
  final String prsMiddleName;
  final String prsFamilyName;
  final String prsFullEnglishName;
  final Timestamp prsBirthDay;
  final String prsMaritalStatusId;
  final String prsMaritalStatusNameAr;
  final String prsMaritalStatusNameEn;
  final String prsNationalityId;
  final String prsNationalityNameAr;
  final String prsNationalityNameEn;
  final String prsHomeAddress;
  final String prsCityId;
  final String prsCityNameAr;
  final String prsCityNameEn;
  final String prsPOBox;
  final String prsZipCode;
  final String prsTelephone;
  final String prsEmail;
  final String prsInstagram;
  final String prsTwitter;
  final String prsHobbies;
  //Job Feilds
  final bool jobStatus;
  final String jobCompanyName;
  final String jobTitle;
  final String jobLocation;
  final String jobMobile;
  final String jobCityId;
  final String jobCityNameAr;
  final String jobCityNameEn;
  final String jobPOBox;
  final String jobZip;
  final String jobTelephone;
  final String jobEmail;
  final String jobPositions;
  final String jobMainBusiness;
  final String jobWebsite;
  final String jobCompanyTelephone;
  final String jobAssistant;
  final String jobCompanyEmail;
  final String jobCompanySectorId;
  final String jobCompanySectorNameAr;
  final String jobCompanySectorNameEn;

  //Extra Feilds
  final bool extStatus;
  final String extComanyLogoImage;
  final String extIdentityImage;
  final String extPrompted;
  final String extMboMembers;
  final bool extCommitment;

  //Payment Feilds
  final String payId;
  final Timestamp payDateEnd;
  final Timestamp payDateStart;
  final Timestamp payDateTime;
  final int subAmount;
  final String subAr;
  final int subDays;
  final String subEn;
  final String subId;

  MyUser({
    this.usrEmail,
    this.usrId,
    this.usrName,
    this.usrStatus,
    this.usrType,
    this.usrImage,
    this.usrDateTime,
    this.usrSalutationId,
    this.usrSalutationAr,
    this.usrSalutationEn,
    this.usrOnline,
    this.prsStatus,
    this.prsFirstName,
    this.prsMiddleName,
    this.prsFamilyName,
    this.prsFullEnglishName,
    this.prsBirthDay,
    this.prsMaritalStatusId,
    this.prsMaritalStatusNameAr,
    this.prsMaritalStatusNameEn,
    this.prsNationalityId,
    this.prsNationalityNameAr,
    this.prsNationalityNameEn,
    this.prsHomeAddress,
    this.prsCityId,
    this.prsCityNameAr,
    this.prsCityNameEn,
    this.prsPOBox,
    this.prsZipCode,
    this.prsTelephone,
    this.prsEmail,
    this.prsInstagram,
    this.prsTwitter,
    this.prsHobbies,
    //Job Felids
    this.jobStatus,
    this.jobCompanyName,
    this.jobTitle,
    this.jobLocation,
    this.jobMobile,
    this.jobCityId,
    this.jobCityNameAr,
    this.jobCityNameEn,
    this.jobPOBox,
    this.jobZip,
    this.jobTelephone,
    this.jobEmail,
    this.jobPositions,
    this.jobMainBusiness,
    this.jobWebsite,
    this.jobCompanyTelephone,
    this.jobAssistant,
    this.jobCompanyEmail,
    this.jobCompanySectorId,
    this.jobCompanySectorNameAr,
    this.jobCompanySectorNameEn,
    //Extra Feilds
    this.extStatus,
    this.extComanyLogoImage,
    this.extIdentityImage,
    this.extPrompted,
    this.extMboMembers,
    this.extCommitment,
    //Payment Feilds
    this.payId,
    this.payDateEnd,
    this.payDateStart,
    this.payDateTime,
    this.subAmount,
    this.subAr,
    this.subDays,
    this.subEn,
    this.subId,
  });

  factory MyUser.fromDocument(DocumentSnapshot doc) {
    //print(doc.data()["usrName"]);
    if (doc.data() != null) {
      return MyUser(
        usrEmail: doc.data()['usrEmail'],
        usrId: doc.data()['usrId'],
        usrName: doc.data()['usrName'],
        usrStatus: doc.data()['usrStatus'],
        usrType: doc.data()['usrType'],
        usrImage: doc.data()['usrImage'],
        usrDateTime: doc.data()['usrDateTime'],
        usrOnline: doc.data()['usrOnline'],

        usrSalutationId: doc.data()['usrSalutationId'],
        usrSalutationAr: doc.data()['usrSalutationAr'],
        usrSalutationEn: doc.data()['usrSalutationEn'],

        prsStatus: doc.data()['prsStatus'],
        prsFirstName: doc.data()['prsFirstName'],
        prsMiddleName: doc.data()['prsMiddleName'],
        prsFamilyName: doc.data()['prsFamilyName'],
        prsFullEnglishName: doc.data()['prsFullEnglishName'],
        prsBirthDay: doc.data()['prsBirthDay'],
        prsMaritalStatusId: doc.data()['prsMaritalStatusId'],
        prsMaritalStatusNameAr: doc.data()['prsMaritalStatusNameAr'],
        prsMaritalStatusNameEn: doc.data()['prsMaritalStatusNameEn'],
        prsNationalityId: doc.data()['prsNationalityId'],
        prsNationalityNameAr: doc.data()['prsNationalityNameAr'],
        prsNationalityNameEn: doc.data()['prsNationalityNameEn'],
        prsHomeAddress: doc.data()['prsHomeAddress'],

        prsCityId: doc.data()['prsCityId'],
        prsCityNameAr: doc.data()['prsCityNameAr'],
        prsCityNameEn: doc.data()['prsCityNameEn'],

        prsPOBox: doc.data()['prsPOBox'],
        prsZipCode: doc.data()['prsZipCode'],
        prsTelephone: doc.data()['prsTelephone'],
        prsEmail: doc.data()['prsEmail'],
        prsInstagram: doc.data()['prsInstagram'],
        prsTwitter: doc.data()['prsTwitter'],
        prsHobbies: doc.data()['prsHobbies'],
        //Job Feilds
        jobStatus: doc.data()['jobStatus'],
        jobCompanyName: doc.data()['jobCompanyName'],
        jobTitle: doc.data()['jobTitle'],
        jobLocation: doc.data()['jobLocation'],
        jobMobile: doc.data()['jobMobile'],
        jobCityId: doc.data()['jobCityId'],
        jobCityNameAr: doc.data()['jobCityNameAr'],
        jobCityNameEn: doc.data()['jobCityNameEn'],
        jobPOBox: doc.data()['jobPOBox'],
        jobZip: doc.data()['jobZip'],
        jobTelephone: doc.data()['jobTelephone'],
        jobEmail: doc.data()['jobEmail'],
        jobPositions: doc.data()['jobPositions'],
        jobMainBusiness: doc.data()['jobMainBusiness'],
        jobWebsite: doc.data()['jobWebsite'],
        jobCompanyTelephone: doc.data()['jobCompanyTelephone'],
        jobAssistant: doc.data()['jobAssistant'],
        jobCompanyEmail: doc.data()['jobCompanyEmail'],
        jobCompanySectorId: doc.data()['jobCompanySectorId'],
        jobCompanySectorNameAr: doc.data()['jobCompanySectorNameAr'],
        jobCompanySectorNameEn: doc.data()['jobCompanySectorNameEn'],
        //Extra Feilds
        extStatus: doc.data()['extStatus'],
        extComanyLogoImage: doc.data()['extComanyLogoImage'],
        extIdentityImage: doc.data()['extIdentityImage'],
        extPrompted: doc.data()['extPrompted'],
        extMboMembers: doc.data()['extMboMembers'],
        extCommitment: doc.data()['extCommitment'],

        //Payment Feilds
        payId: doc.data()['payId'],
        payDateEnd: doc.data()['payDateEnd'],
        payDateStart: doc.data()['payDateStart'],
        payDateTime: doc.data()['payDateTime'],
        subAmount: doc.data()['subAmount'],
        subAr: doc.data()['subAr'],
        subDays: doc.data()['subDays'],
        subEn: doc.data()['subEn'],
        subId: doc.data()['subId'],
      );
    }
    return null;
  }
}
