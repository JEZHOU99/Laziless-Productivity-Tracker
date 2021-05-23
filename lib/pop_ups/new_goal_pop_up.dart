import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:laziless/services/update_service.dart';
import 'package:laziless/tools/pop_up_close.dart';

class NewGoalForm extends StatefulWidget {
  NewGoalForm({this.user});
  final FirebaseUser user;
  @override
  _NewGoalFormState createState() => _NewGoalFormState();
}

class _NewGoalFormState extends State<NewGoalForm> {
  // create some values
  Color pickerColor = Color(0xff27ABB5);
  Color currentColor = Color(0xff27ABB5);

  double hours;
  String name;

  final _formkey = GlobalKey<FormState>();
  TextEditingController activityController;
  TextEditingController hoursController;

  @override
  void initState() {
    super.initState();
    activityController = TextEditingController();
    hoursController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    activityController.dispose();
    hoursController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int seconds = hours != null ? (hours * 3600).toInt() : 0;

    return Container(
      height: 300,
      width: 300,
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 12),
                child: Text(
                  "New Goal",
                  style: TextStyle(
                      color: currentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
              PopUpClose(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 55.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30.0, 30, 30, 20),
                          child: TextFormField(
                            controller: activityController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.label),
                              errorStyle: TextStyle(color: Colors.red),
                              hintText: "Activity",
                            ),
                            validator: (val) => val.isEmpty
                                ? 'Please enter an activity name'
                                : null,
                            onChanged: (val) {
                              setState(() => name = val);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 10),
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                    onTap: () => showDialog(
                                          context: context,
                                          child: AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(32.0))),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 20, 20, 0),
                                            title: const Text('Pick a color!'),
                                            content: SingleChildScrollView(
                                              child: ColorPicker(
                                                pickerColor: pickerColor,
                                                onColorChanged: changeColor,
                                                showLabel: false,
                                                enableAlpha: false,
                                                pickerAreaBorderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: const Text('Got it'),
                                                onPressed: () {
                                                  setState(() {
                                                    currentColor = pickerColor;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: currentColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 55.0),
                                child: TextFormField(
                                  controller: hoursController,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.access_time),
                                    hintText: "Hours per week",
                                    errorStyle: TextStyle(color: Colors.red),
                                  ),
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Please enter a weekly goal";
                                    } else if (double.parse(val) > 168) {
                                      return "There are 168 hours in a week...";
                                    }
                                    return null;
                                  },
                                  onChanged: (val) =>
                                      setState(() => hours = double.parse(val)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                color: currentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                onPressed: () async {
                  if (_formkey.currentState.validate()) {
                    addGoalService(
                        widget.user, seconds, name.trim(), currentColor.value);
                    activityController.clear();
                    hoursController.clear();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                child: Text(
                  "Add",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      currentColor = pickerColor;
    });
  }
}

openNewGoalPopUp(context, FirebaseUser user) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: NewGoalForm(user: user));
      });
}
