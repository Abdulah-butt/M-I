import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rollingball/constant/screen_size.dart';
import 'package:rollingball/util/custom_color.dart';
import 'package:rollingball/util/custom_style.dart';

Widget socialButton(String path,String text) {
  return Container(
    width: ScreenSize.width * 0.9,
    height: 50,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(path),
        Text(
          text,
          style: TextStyle(fontSize: 14,color: blueTextColor),
        ),
        SizedBox(width: ScreenSize.width*0.1,)

      ],
    ),
    decoration:textFieldDecoration(),
  );
}


// loading widget

Future<dynamic> customloadingIndicator(BuildContext context) {
  return showDialog(
      context: context,
      builder: (ctx) {
        return Material(
          color: Colors.white.withOpacity(0.3),
          child: const Center(child: CircularProgressIndicator()),
        );
      });
}