import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbo/classes/date_formatter.dart';
import 'package:mbo/main.dart';
import 'package:mbo/wedgits/dialogs.dart';
import 'package:mbo/wedgits/masterLabel.dart';
import 'package:mbo/wedgits/settings.dart';

class EventsEditPage extends StatefulWidget {
  final recordDate;
  EventsEditPage({this.recordDate, Key key}) : super(key: key);

  @override
  _EventsEditPageState createState() => _EventsEditPageState();
}

class _EventsEditPageState extends State<EventsEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _autoValidate = AutovalidateMode.disabled;
  String _errorMasseges;

  final evntNameController = TextEditingController();
  final evntDescriptionController = TextEditingController();
  final evntAddressController = TextEditingController();
  final evntStartDateController = TextEditingController();
  final evntEndDateController = TextEditingController();
  final evntStartTimeController = TextEditingController();
  final evntEndTimeController = TextEditingController();
  final evntExtraInfoController = TextEditingController();

  String evntCityController;
  List<DropdownMenuItem<String>> city = [];
  Map mapCity = {};

  TimeOfDay startTime;
  TimeOfDay endTime;

  @override
  void initState() {
    super.initState();
    loadFormData();
    fillFormData();
    print(widget.recordDate.toString());
  }

  fillFormData() {
    evntNameController.text = widget.recordDate['evntName'];
    evntDescriptionController.text = widget.recordDate['evntDescription'];
    evntExtraInfoController.text = widget.recordDate['evntExtraInfo'];
    evntAddressController.text = widget.recordDate['evntAddress'];
    evntStartDateController.text =
        timestampTodate(widget.recordDate['evntStartDate']);
    evntStartTimeController.text =
        timestampTotime(widget.recordDate['evntStartTime']);
    evntEndTimeController.text =
        timestampTotime(widget.recordDate['evntEndTime']);
    evntCityController = widget.recordDate['evntCityId'];
    startTime =
        TimeOfDay.fromDateTime(widget.recordDate['evntStartTime'].toDate());
    endTime = TimeOfDay.fromDateTime(widget.recordDate['evntEndTime'].toDate());
  }

  loadFormData() async {
    //print('loadFormData loadFormData loadFormData');
    mapCity = {};
    city = [];
    await lookUpCitiesRef.get().then((doc) {
      doc.docs.forEach((doc) {
        mapCity[doc.id] = {
          'ctyId': doc.id,
          'ctyAr': doc.data()['ctyAr'],
          'ctyEn': doc.data()['ctyEn'],
        };
        city.add(
          DropdownMenuItem(
            value: doc.id,
            child: Text(
              doc.data()['ctyAr'] + ' / ' + doc.data()['ctyEn'],
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      });
    }).whenComplete(() {
      setState(() {
        city = city;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1925, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        evntStartDateController.text = dateTimeToDate(picked);
      });
  }

  Future<void> _selectTime(BuildContext context, String evntController) async {
    DateTime selectedTime = DateTime.now();
    print(selectedTime.toString());
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime:
          (evntController == 'evntStartTimeController') ? startTime : endTime,
    );
    if (picked != null) {
      print(picked.toString());
      setState(() {
        if (evntController == 'evntStartTimeController') {
          evntStartTimeController.text =
              picked.hour.toString() + ":" + picked.minute.toString();
          startTime = picked;
        }
        if (evntController == 'evntEndTimeController') {
          evntEndTimeController.text =
              picked.hour.toString() + ":" + picked.minute.toString();
          endTime = picked;
        }
      });
    }
  }

  handleEditEvent() {
    Dialogs.showLoadingDialog(context, _keyLoader);

    bool _evntStatus = true;
    String _evntName = evntNameController.text;
    String _evntDescription = evntDescriptionController.text;
    String _evntAddress = evntAddressController.text;
    String _evntExtraInfo = evntExtraInfoController.text;
    String _evntCityId = mapCity[evntCityController]['ctyId'];
    String _evntCityNameAr = mapCity[evntCityController]['ctyAr'];
    String _evntCityNameEn = mapCity[evntCityController]['ctyEn'];

    DateTime _evntStartDate = DateTime.parse(evntStartDateController.text);
    DateTime _evntEndDate = _evntStartDate;

    DateTime _evntStartTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        startTime.hour,
        startTime.minute);
    DateTime _evntEndTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, endTime.hour, endTime.minute);
    print(_evntStartTime);

    eventsRef.doc(widget.recordDate['evntId']).update({
      'evntStatus': _evntStatus,
      'evntName': _evntName,
      'evntDescription': _evntDescription,
      'evntAddress': _evntAddress,
      'evntExtraInfo': _evntExtraInfo,
      'evntCityId': _evntCityId,
      'evntCityNameAr': _evntCityNameAr,
      'evntCityNameEn': _evntCityNameEn,
      'evntStartDate': _evntStartDate,
      'evntEndDate': _evntEndDate,
      'evntStartTime': _evntStartTime,
      'evntEndTime': _evntEndTime,
    }).then((value) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Dialogs.alertDialog(context, 'تم تعديل المعلومات بنجاح');
    }).catchError((onError) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      _errorMasseges = 'حدث خلل أثناء إجراء العملية. نرجو المحاولة مرة أخرى';
      if (_errorMasseges.isNotEmpty) {
        Dialogs.alertDialog(context, _errorMasseges);
      }
    }).whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة مناسبة'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (contextx) => SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: MasterLabel(
                      content: Text(
                        'اسم وتفاصيل المناسبة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      theColor: darkGreen,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                    child: TextFormField(
                      controller: evntNameController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'اسم المناسبة',
                        hintText: 'العنوان',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'هذا الحقل مطلوب';
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
                      controller: evntDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'وصف المناسبة',
                        hintText: 'الوصف',
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
                      controller: evntExtraInfoController,
                      decoration: InputDecoration(
                        labelText: 'معلومات إضافية',
                        hintText: 'معلومات إضافية',
                      ),
                      maxLines: 3,
                      minLines: 2,
                    ),
                  ),

///////////////////////////////////////
                  SizedBox(
                    width: double.infinity,
                    child: MasterLabel(
                      content: Text(
                        'موقع وعنوان المناسبة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      theColor: darkGreen,
                    ),
                  ),
///////////////////////////////////////
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                    child: DropdownButtonFormField(
                      value: evntCityController,
                      decoration: InputDecoration(
                        labelText: 'المدينة',
                        hintText: 'المدينة',
                      ),
                      items: city.toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return city.toList();
                      },
                      onChanged: (value) {
                        setState(() {
                          evntCityController = value;
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

///////////////////////////////////////

                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                    child: TextFormField(
                      autocorrect: false,
                      controller: evntAddressController,
                      decoration: InputDecoration(
                        labelText: 'موقع المناسبة',
                        hintText: 'العنوان',
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
                        'التاريخ والوقت',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      theColor: darkGreen,
                    ),
                  ),

///////////////////////////////////////

                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                    child: TextFormField(
                      autocorrect: false,
                      controller: evntStartDateController,
                      decoration: InputDecoration(
                        labelText: 'تاريخ المناسبة',
                        hintText: 'التاريخ',
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'الحقل مطلوب / Required Field';
                        }
                        return null;
                      },
                      onTap: () => _selectDate(context),
                    ),
                  ),
///////////////////////////////////////
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                    child: TextFormField(
                      autocorrect: false,
                      controller: evntStartTimeController,
                      decoration: InputDecoration(
                        labelText: 'يبدأ في الساعة',
                        hintText: 'الساعة',
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'الحقل مطلوب / Required Field';
                        }
                        return null;
                      },
                      onTap: () =>
                          _selectTime(context, 'evntStartTimeController'),
                    ),
                  ),
///////////////////////////////////////
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                    child: TextFormField(
                      keyboardType: TextInputType.datetime,
                      autocorrect: false,
                      controller: evntEndTimeController,
                      decoration: InputDecoration(
                        labelText: 'ينتهى في الساعة',
                        hintText: 'الساعة',
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'الحقل مطلوب / Required Field';
                        }
                        return null;
                      },
                      onTap: () =>
                          _selectTime(context, 'evntEndTimeController'),
                    ),
                  ),
///////////////////////////////////////

                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                      child: RaisedButton(
                        child: Text(
                          'تعديل المعلومات',
                        ),
                        textColor: Colors.white,
                        color: darkGreen,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            handleEditEvent();
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
