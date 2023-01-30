import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postitapp/Utils/utils.dart';
import 'package:postitapp/Widgets/round_button.dart';
import 'package:postitapp/ui/auth/login_withPhonenumber.dart';
import 'package:postitapp/ui/auth/signup.dart';

import '../post/postScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login(){
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text.toString())
        .then((value){
          Utils().toastMessage(value.user!.email.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context)=> PostScreen()));
          setState(() {
            loading = false;
          });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
    });
    setState(() {
      loading= false;
    });

  }


  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar
          (
          title: Center(child: Text('Login page')),
        ),
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
                    child: RoundButton(title: 'Login',
                      loading: loading,onTap: () {

                      if(_formKey.currentState!.validate()){
                        login();
                      }
                    },),


                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                    }, child: Text('SignUp'))
                  ],
                ),
                SizedBox(height: 30,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginWithPhoneNumber()));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.tealAccent,

                      ),

                    ),
                    child: Center(child: Text('Login With Phone Number')),
                  ),
                )
              ],

            ),
          ),
        ),
      ),
    );
  }
}
