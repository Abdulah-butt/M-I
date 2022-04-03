
import 'package:flutter/material.dart';

import 'custom_color.dart';

TextStyle buttonTextStyle(){
  return const TextStyle(
      color:Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold
  );
}


ButtonStyle buttonStyle(){
  return ElevatedButton.styleFrom(
    primary:appBarColor,
    elevation: 5,
    shape: RoundedRectangleBorder( //to set border radius to button
        borderRadius: BorderRadius.circular(20)
    ),
  );
}


BoxDecoration textFieldDecoration(){
  return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.black26)
    //shape: BoxShape.circle,
  );
}