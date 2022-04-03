
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rollingball/constant/my_constant.dart';
import 'package:rollingball/services/social_authentication.dart';
import 'package:rollingball/util/routes.dart';
import 'package:rollingball/view/guest_screen.dart';
import 'package:rollingball/view/home_screen.dart';
import 'package:rollingball/view/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue
  ));


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userID = prefs.getString('userID')??'';
  if(userID!=''){
    print("userID is $userID");
    MyConstant.currentUserId=userID;
  }

  runApp(
      MaterialApp(

        initialRoute:userID==''?MyRoutes.signInScreen:MyRoutes.homeScreen,
        routes:{
          MyRoutes.signInScreen:(context)=>SignInScreen(),
          MyRoutes.homeScreen:(context)=>HomeScreen(),
          MyRoutes.guestScreen:(context)=>GuestScreen(),
        },
      )
  );
}