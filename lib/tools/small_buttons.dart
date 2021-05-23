import 'package:flutter/material.dart';

class SmallRaisedButton extends StatelessWidget {
  const SmallRaisedButton({Key key, this.text, this.icon, this.onpressed})
      : super(key: key);
  final String text;
  final IconData icon;
  final Function onpressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: MaterialButton(
        padding: EdgeInsets.all(0),
        onPressed: onpressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).textSelectionColor,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 12, color: Theme.of(context).textSelectionColor),
            )
          ],
        ),
      ),
    );
  }
}
