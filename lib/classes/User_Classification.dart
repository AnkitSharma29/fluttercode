import 'package:flutter/material.dart';
import 'package:mbo/wedgits/settings.dart';

Map<String, Object> getUserClassification(int usrType, int usrStatus) {
  String currentTitle;
  String currentStatus;
  String currentType;

  Color currentBackColor = masterBlue;
  Color currentForeColor = Colors.white;
  switch (usrType) {
    case 0:
      currentType = 'محظور';
      currentBackColor = Colors.red[400];
      currentForeColor = Colors.white;
      switch (usrStatus) {
        case -2:
          currentTitle = 'محظور - غير مكتمل';
          currentStatus = 'غير مكتمل البيانات';
          break;
        case -1:
          currentTitle = 'محظور - مكتمل';
          currentStatus = 'مكتمل البيانات';
          break;
        case 0:
          currentTitle = 'محظور - غير مشترك';
          currentStatus = 'غير مشترك';
          break;
        case 1:
          currentTitle = 'محظور - مشترك';
          currentStatus = 'مشترك';
          break;
        default:
          currentTitle = 'محظور - غير محدد';
          currentStatus = 'غير محدد';
      }
      break;
    case 1:
      currentType = 'عضو';
      switch (usrStatus) {
        case -2:
          currentTitle = 'عضو - غير مكتمل';
          currentStatus = 'غير مكتمل البيانات';
          currentBackColor = bgGray;
          currentForeColor = Colors.grey[700];
          break;
        case -1:
          currentTitle = 'عضو - مكتمل';
          currentStatus = 'مكتمل البيانات';
          currentBackColor = lightGreen;
          currentForeColor = Colors.grey[700];
          break;
        case 0:
          currentTitle = 'عضو - غير مشترك';
          currentStatus = 'غير مشترك';
          currentBackColor = darkGreen;
          currentForeColor = Colors.white70;

          break;
        case 1:
          currentTitle = 'عضو - مشترك';
          currentStatus = 'مشترك';
          currentBackColor = masterBlue;
          currentForeColor = Colors.white70;
          break;
        default:
          currentTitle = 'عضو - غير محدد';
          currentStatus = 'غير محدد';
          currentBackColor = Colors.orange[600];
          currentForeColor = Colors.white70;
      }
      break;
    case 2:
      currentType = 'إداري';
      switch (usrStatus) {
        case 0:
          currentTitle = 'إدري - محظور';
          currentStatus = 'محظور';
          currentBackColor = Colors.red[400];
          currentForeColor = Colors.white;

          break;
        case 1:
          currentTitle = 'إداري - فاعل';
          currentStatus = 'فاعل';
          currentBackColor = masterBlue;
          currentForeColor = Colors.white;
          break;
        default:
          currentTitle = 'إداري - غير محدد';
          currentStatus = 'غير محدد';
          currentBackColor = Colors.orange[600];
          currentForeColor = Colors.white70;
      }
      break;
    default:
      currentTitle = 'غير محدد';
      currentBackColor = Colors.white;
      currentForeColor = masterBlue;
      currentType = 'غير معروف';
      currentStatus = 'غير محدد';
  }

  return {
    'currentTitle': currentTitle,
    'currentBackColor': currentBackColor,
    'currentForeColor': currentForeColor,
    'currentType': currentType,
    'currentStatus': currentStatus,
  };
}
