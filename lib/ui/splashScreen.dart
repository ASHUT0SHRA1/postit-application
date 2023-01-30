
import 'package:flutter/material.dart';
import 'package:postitapp/firebaseservice/splashservices.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.isLogin(context);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircleAvatar(
          radius: 120,
          backgroundColor: Colors.deepOrange,
          child: CircleAvatar(
            radius: 110,
            backgroundColor: Colors.tealAccent,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.redAccent,
              child: CircleAvatar(
                // backgroundImage: AssetImage('assets/images/123.jpg'),
                radius: 90,
                child: Text('P0STIT',style: TextStyle(fontStyle: FontStyle.italic,fontSize: 34,fontWeight: FontWeight.w800,color: Colors.cyanAccent),),
              ),
            ),
          ),
        ),
      ),
        );
    // );
  }
}
