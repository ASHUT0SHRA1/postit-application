
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:postitapp/Utils/utils.dart';
import 'package:postitapp/Widgets/round_button.dart';
import 'package:postitapp/ui/auth/verifyphonenumber.dart';
class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login')),
      ),
      body: Column(
        children: [
          SizedBox(height: 50,),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: phoneNumberController,
                decoration: InputDecoration(
                  hintText: "+91 1234567890",

                ),
              ),

            ),

          ),
          SizedBox(height: 30,),
          RoundButton(title: 'Verify',loading: loading, onTap: (){
            setState(() {
              loading = true;
            });

            auth.verifyPhoneNumber(
                phoneNumber : phoneNumberController.text,

                verificationCompleted: (_){
                  setState(() {
                    loading = false;
                  });
                },
                verificationFailed: (e){

                  setState(() {
                    loading = false;
                  });
                Utils().toastMessage(e.toString());
                },
                codeSent: (String verificationId, int? toeken) {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyCodeScreen(verificationId: verificationId)));


                  setState(() {
                    loading = false;
                  }); },
                codeAutoRetrievalTimeout: (e){
                  Utils().toastMessage(e.toString());

                  setState(() {
                    loading = false;
                  });
                });
          })
        ],

      ),
    );
  }
}
