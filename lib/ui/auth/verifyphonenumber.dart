import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:postitapp/ui/post/postScreen.dart';

import '../../Utils/utils.dart';
import '../../Widgets/round_button.dart';
class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final verifycodeController = TextEditingController();
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
                controller: verifycodeController,
                decoration: InputDecoration(
                  hintText: "6 Digit Code",

                ),
              ),

            ),

          ),
          SizedBox(height: 30,),
          RoundButton(title: 'Verify',loading: loading, onTap: () async {
            setState(() {
              loading = true;
            });
            final credential = PhoneAuthProvider.credential(verificationId: widget.verificationId,
                smsCode: verifycodeController.text.toString());
            try{
              await auth.signInWithCredential(credential);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
            }catch(e){
              setState(() {
                loading = false;
              });
            }
          })
        ],

      ),
    );
  }
}
