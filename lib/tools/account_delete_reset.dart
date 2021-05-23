import 'package:flutter/material.dart';
import 'package:laziless/tools/pop_up_close.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

openResetDeleteConfirmation(context, text, preview, onTap) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              height: 300,
              width: 200,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            PopUpClose(),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Text(
                                  text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 8),
                                child: Container(
                                    alignment: Alignment.topCenter,
                                    child: preview),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ConfirmationSlider(
                        onConfirmation: onTap,
                        width: 250,
                        foregroundColor: Theme.of(context).primaryColor,
                        text: "         Slide to confirm",
                      ),
                    ),
                  ),
                ],
              ),
            ));
      });
}
