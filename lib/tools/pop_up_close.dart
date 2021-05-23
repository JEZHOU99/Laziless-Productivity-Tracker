import 'package:flutter/material.dart';

class PopUpClose extends StatelessWidget {
  const PopUpClose({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.only(right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.close,
              color: Colors.grey,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              "Close",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
