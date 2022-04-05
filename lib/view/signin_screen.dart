import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rollingball/constant/screen_size.dart';
import 'package:rollingball/services/social_authentication.dart';
import 'package:rollingball/util/assets_path.dart';
import 'package:rollingball/util/custom_color.dart';
import 'package:rollingball/util/custom_style.dart';
import 'package:rollingball/util/routes.dart';
import 'package:rollingball/widgets/custom_widgets.dart';
import 'dart:developer';

import '../constant/my_constant.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    // getting screen size
    ScreenSize.width=MediaQuery.of(context).size.width;
    ScreenSize.height=MediaQuery.of(context).size.height;


    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            InkWell(
                onTap: () async {
                  customloadingIndicator(context);
                  bool result=await SocialAuthentication.signInWithGoogle();
                  Navigator.pop(context);
                  if(result){
                    Navigator.pushNamed(context, MyRoutes.homeScreen);
                  }

                },
                child: socialButton(AssetsPath.googlePath,"Continue with Google")),
            SizedBox(height: 20,),
            InkWell(
                onTap: () async {
                  customloadingIndicator(context);
                 bool result=await SocialAuthentication.signInWithFacebook();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  if(result){
                    Navigator.pushNamed(context, MyRoutes.homeScreen);
                  }
                },
                child: socialButton(AssetsPath.facebookPath,"Continue with Facebook")),

            SizedBox(height: 20,),
            Text("OR"),
            SizedBox(height: 20,),

            InkWell(
              onTap: (){
                Navigator.pushNamed(context, MyRoutes.guestScreen);
              },
              child: Container(
                width: ScreenSize.width * 0.9,
                height: 50,
                child: Center(child:Text("Continue as Guest", style: TextStyle(fontSize: 14,color: blueTextColor),),),
                decoration:textFieldDecoration(),
              ),
            )

          ],
        ),
      ),
    );
  }
}
