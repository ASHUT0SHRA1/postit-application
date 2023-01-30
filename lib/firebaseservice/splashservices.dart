import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:postitapp/ui/auth/firestore/firestore_list_screen.dart';
import '../ui/auth/loginscreen.dart';
import '../ui/post/postScreen.dart';

class SplashServices{
  void isLogin(context){
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    // if user is not null mean user value is there data is there
    if(user != null){
      Timer.periodic(Duration(seconds: 3), (timer) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PostScreen()));
      });
    }else{
      Timer.periodic(Duration(seconds: 3), (timer) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      });
    }

  }
}