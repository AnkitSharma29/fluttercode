import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String dateTimeToDate(DateTime theDateTime) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
  final DateTime displayDate = displayFormater.parse(theDateTime.toString());
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

String dateTimeToTime(DateTime theDateTime) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat('HH:mm');
  final DateTime displayDate = displayFormater.parse(theDateTime.toString());
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

String timestampTodate(Timestamp theTimestamp) {
  var formatter = new DateFormat('yyyy-MM-dd');
  var newtheDateTime = DateTime.parse(theTimestamp.toDate().toString());
  var formatted = formatter.format(newtheDateTime);
  return formatted; // something like 2013-04-20
}

String timestampTotime(Timestamp theTimestamp) {
  var formatter = new DateFormat('hh:mm');
  var newtheDateTime = DateTime.parse(theTimestamp.toDate().toString());
  var formatted = formatter.format(newtheDateTime);
  return formatted; // something like 2013-04-20
}

timestampToDatetime(Timestamp theTimestamp) {
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  var newtheDateTime = DateTime.parse(theTimestamp.toDate().toString());
  var formatted = formatter.format(newtheDateTime);
  return formatted; // something like 2013-04-20
}

getAgeByYear(Timestamp usrMemDate) {
  DateTime dob = usrMemDate.toDate();
  Duration dur = DateTime.now().difference(dob);
  int differenceInYears = (dur.inDays / 365).floor();
  if (differenceInYears < 1) {
    differenceInYears = 1;
  }
  return differenceInYears;
}

String getDaysDifference(DateTime startDate, DateTime endDate) {
  int nbDays = 0;
  nbDays = startDate.difference(endDate).inDays;
  if (nbDays < 0) nbDays = 0;
  return nbDays.toString();
}
