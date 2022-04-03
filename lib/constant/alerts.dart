import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyAlert{

  static void showToast(String txt){
    Fluttertoast.showToast(
        msg:txt,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.deepOrangeAccent,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }

}