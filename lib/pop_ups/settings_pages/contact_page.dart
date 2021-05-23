import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();

  String email = "";
  String subject = "";
  String message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: "Contact Us",
          child: Material(
            color: Colors.transparent,
            child: Text(
              "Contact Us",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Form(
          key: _formkey,
          child: ListView(physics: BouncingScrollPhysics(), children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //_emailSection(),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: Text(
                      "Topic",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "What is your message about?",
                        border: InputBorder.none,
                      ),
                      validator: (val) => val.isEmpty ? 'Enter a topic' : null,
                      onChanged: (val) {
                        setState(() => subject = val);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Text(
                    "Content",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Write your message here..."),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please a message";
                        } else if (val.trim().length < 10) {
                          return "Please enter a message longer than 10 characters";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() => message = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      print("hi");
                      sendMessage(message, subject);
                    }
                  },
                  child: Text(
                    "Send",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  sendMessage(
    String message,
    String subject,
  ) async {
    final MailOptions mailOptions = MailOptions(
      body: message.trim(),
      subject: subject.trim(),
      recipients: ['staff.laziless@gmail.com'],
      isHTML: true,
    );

    try {
      await FlutterMailer.send(mailOptions);
    } catch (e) {
      print(e);
    }
  }
}
