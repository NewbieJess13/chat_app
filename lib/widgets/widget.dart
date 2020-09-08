import 'package:flutter/material.dart';

Widget appbarMain(BuildContext context,String title) {
  return AppBar(
    title: Row(
      children: <Widget>[
        Image.asset(
          "assets/images/logo.png",
          width: 50,
          height: 60,
        ),
        SizedBox(width: 5,),
        Text(title,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
      ],
    ),
    backgroundColor: Colors.deepOrangeAccent,
    elevation: 0,
  );
}

InputDecoration textFieldInputDecoration(String hint) {
  return InputDecoration(
    labelText: hint,
   // hintText: hint,
    labelStyle: TextStyle(color: Colors.white54),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16
  );
}

TextStyle mediumTextStyle() {
  return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 15);
}
