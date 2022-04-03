import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:rollingball/constant/alerts.dart';
import 'package:rollingball/constant/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SocialAuthentication{

  static final googleSignIn=GoogleSignIn();

  static Future<bool> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential= await FirebaseAuth.instance.signInWithCredential(credential);
      MyConstant.currentUserId=userCredential.user!.uid;
      print("use id is ${ MyConstant.currentUserId}");
      saveUser( MyConstant.currentUserId);

      createAccount();

      return true;
    }catch(e){
      MyAlert.showToast(e.toString());
      return false;
    }

  }

  static Future<bool> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider
          .credential(loginResult.accessToken!.token);

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      MyConstant.currentUserId = userCredential.user!.uid;
      print("use id from facebook ${ MyConstant.currentUserId}");
      saveUser( MyConstant.currentUserId);
      createAccount();
      return true;
    }catch(e){
      MyAlert.showToast(e.toString());
      return false;
    }
  }

  static logoutGoogle() async {
    await googleSignIn.disconnect();
    logoutUser();
    FirebaseAuth.instance.signOut();
  }

 static createAccount() async {
    DocumentSnapshot doc=await FirebaseFirestore.instance.collection('users').doc(MyConstant.currentUserId).collection('points').doc(MyConstant.currentUserId).get();
    if(doc.exists){

    }else {
      FirebaseFirestore.instance.collection('users').doc(MyConstant.currentUserId).collection('points').doc(MyConstant.currentUserId).set({
        'points': 0
      });
    }
  }
  static Future<bool> saveUser(String userID) async {
    print("Saved");
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userID", userID);
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }



  static Future<bool> logoutUser() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }
}