import 'package:flutter/material.dart';

import 'package:laziless/tools/pop_up_close.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterOrderPopUp extends StatefulWidget {
  // create some values

  @override
  _FilterOrderPopUpState createState() => _FilterOrderPopUpState();
}

class _FilterOrderPopUpState extends State<FilterOrderPopUp> {
  String sortByRadioValue;
  String sortByDirection;

  @override
  void initState() async {
    super.initState();
    await _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight * 0.7,
      width: screenWidth * 0.7,
      child: Column(
        children: <Widget>[
          PopUpClose(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Text(
                    "Sort By:",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700),
                  ),
                  ListTile(
                    title: const Text('Name'),
                    leading: Radio(
                      value: "Name",
                      groupValue: sortByRadioValue,
                      onChanged: (value) {
                        setState(() {
                          sortByRadioValue = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Weekly Goal'),
                    leading: Radio(
                      value: "Weekly Goal",
                      groupValue: sortByRadioValue,
                      onChanged: (value) {
                        setState(() {
                          sortByRadioValue = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Current Progress'),
                    leading: Radio(
                      value: "Current Progress",
                      groupValue: sortByRadioValue,
                      onChanged: (value) {
                        setState(() {
                          sortByRadioValue = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Direction:",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700),
                    ),
                  ),
                  ListTile(
                    title: const Text('Ascending'),
                    leading: Radio(
                      value: "Ascending",
                      groupValue: sortByDirection,
                      onChanged: (value) {
                        setState(() {
                          sortByDirection = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Descending'),
                    leading: Radio(
                      value: "Descending",
                      groupValue: sortByDirection,
                      onChanged: (value) {
                        setState(() {
                          sortByDirection = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
              onPressed: () {
                _savePreferences();
                Navigator.of(context).pop();
              },
              child: Text(
                "Save",
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).primaryColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("Sort By", sortByRadioValue);
    await prefs.setString("Sort Direction", sortByDirection);
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sortByRadioValue = prefs.getString("Sort By");
    sortByDirection = prefs.getString("Sort Direction");
  }
}

openFilterPopUp(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: FilterOrderPopUp());
      });
}
