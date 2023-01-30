import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:postitapp/Utils/utils.dart';
import 'package:postitapp/Widgets/round_button.dart';

import 'loginscreen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void login(){
    if(_formKey.currentState!.validate()){
      setState(() {
        loading = true;
      });
      _auth.createUserWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString(

      )).then((value){
        setState(() {
          loading = false;
        });

      }).onError((error, stackTrace){
        Utils().toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,

                        decoration: InputDecoration(
                            hintText: 'email',
                            helperText: 'example@gmail.com',
                            suffixIcon: Icon(Icons.email_outlined,color: Colors.teal,)
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter Email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),

                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'password',
                            helperText: 'password should be greater than 6 ',
                            suffixIcon: Icon(Icons.remove_red_eye,color: Colors.teal,)
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter Password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,)


                    ],
                  )),
              Center(
                child: Container(
                  child: RoundButton(title: 'SignUp',loading: loading , onTap: () {
                    login();
                  },),


                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Already have an account?"),
                  TextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  }, child: Text('Login'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
