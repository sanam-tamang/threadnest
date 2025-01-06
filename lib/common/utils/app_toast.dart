import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  static Future<void> show(String msg, {Color? backgroundColor}) async {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
  
        backgroundColor: backgroundColor ?? Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
