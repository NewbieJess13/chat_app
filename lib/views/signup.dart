import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'chat_rooms_screen.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethod _authMethod = AuthMethod();
  DatabaseMethod _databaseMethod = DatabaseMethod();
  final formKey = GlobalKey<FormState>();

  TextEditingController userNameTextController = new TextEditingController();
  TextEditingController emailTextController = new TextEditingController();
  TextEditingController passwordTextController = new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _authMethod
          .signUpWithEmailAndPassword(
              emailTextController.text, passwordTextController.text)
          .then((value) {
        Map<String, String> userInfoMap = {
          "name": userNameTextController.text,
          "email": emailTextController.text
        };
        HelperFunctions.saveUserNameSharedPref(userNameTextController.text);
        HelperFunctions.saveUserEmailSharedPref(emailTextController.text);
        _databaseMethod.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPref(true);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain(context, 'Sign up'),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
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
                                  return val.isEmpty || val.length < 4
                                      ? "Invalid username."
                                      : null;
                                },
                                controller: userNameTextController,
                                style: simpleTextStyle(),
                                decoration:
                                    textFieldInputDecoration('Username')),
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
                          signMeUp();
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
                          child: Text('Sign Up', style: mediumTextStyle()),
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
                        child: Text('Google Sign Up',
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
                            "Already have an account?",
                            style: mediumTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Sign in now',
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
