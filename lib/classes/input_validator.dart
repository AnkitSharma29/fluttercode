String validateEmail(String value, int errTxt) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    if (errTxt == 0)
      return 'نرجو التأكد من صيغة البريد الإلكتروني';
    else
      return 'تأكد من البريد الإلكتروني / Check Email';
  } else
    return null;
}
