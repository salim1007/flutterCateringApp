import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";

void showToast(String message, Color? backGroundColor, Color? textColor, double fontSize, ToastGravity gravity){
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity,
    timeInSecForIosWeb: 1,
    backgroundColor: backGroundColor,
    textColor: textColor,
    fontSize: fontSize,
  );
}