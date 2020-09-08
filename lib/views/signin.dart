import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chat_rooms_screen.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  QuerySnapshot snapshotUserVal;
  AuthMethod _authMethod = AuthMethod();
  DatabaseMethod _databaseMethod = DatabaseMethod();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextController = new TextEditingController();
  TextEditingController passwordTextController = new TextEditingController();

  signMeIn() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _databaseMethod.getUserByUserEmail(emailTextController.text).then((val) {
        snapshotUserVal = val;
        HelperFunctions.saveUserNameSharedPref(
            snapshotUserVal.docs[0].data()["name"]);
      });
      _authMethod
          .signInWithEmailAndPassword(
              emailTextController.text, passwordTextController.text)
          .then((value) {
        if (value != null) {
          HelperFunctions.saveUserLoggedInSharedPref(true);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain(context, 'Sign In'),
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~"
                                              r"]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)
                                      ? null
                                      : "Enter valid email.";
                                },
                                controller: emailTextController,
                                style: simpleTextStyle(),
                                decoration: textFieldInputDecoration('Email')),
                            TextFormField(
                                obscureText: true,
                                validator: (val) {
                                  return val.length < 7 || val.isEmpty
                                      ? "Choose a stronger password."
                                      : null;
                                },
                                controller: passwordTextController,
                                style: simpleTextStyle(),
                                decoration:
                                    textFieldInputDecoration('Password')),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            'Forgot Password?',
                            style: simpleTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeIn();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.deepOrange[300],
                              Colors.deepOrangeAccent[400],
                            ]),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text('Sign In', style: mediumTextStyle()),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.white,
                            Colors.white70,
                          ]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text('Google Sign In',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have account?",
                            style: mediumTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Sign up now',
                                style: mediumTextStyle().copyWith(
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
