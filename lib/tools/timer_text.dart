import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TimerText extends StatefulWidget {
  final TextStyle styling;
  final Timestamp startTime;
  final bool timerStarted;
  TimerText({Key key, this.styling, this.startTime, this.timerStarted})
      : super(key: key);

  @override
  _TimerTextState createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  int now;
  Timer _everySecond;

  @override
  void initState() {
    super.initState();

    // sets first value
    now = Timestamp.now().millisecondsSinceEpoch;

    // defines a timer
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (widget.timerStarted == true) {
        setState(() {
          now = Timestamp.now().millisecondsSinceEpoch;
        });
      }
    });
  }

  @override
  void dispose() {
    _everySecond?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String hours =
        ((now - widget.startTime.millisecondsSinceEpoch + 1000) ~/ 3600000)
            .toStringAsFixed(0)
            .padLeft(2, "0");
    String minutes =
        (((now - widget.startTime.millisecondsSinceEpoch + 1000) ~/ 60000) % 60)
            .toStringAsFixed(0)
            .padLeft(2, "0");
    String seconds =
        ((((now - widget.startTime.millisecondsSinceEpoch + 1000) ~/ 1000)) %
                60)
            .toStringAsFixed(0)
            .padLeft(2, "0");

    return Text("$hours:$minutes:$seconds", style: widget.styling);
  }
}
