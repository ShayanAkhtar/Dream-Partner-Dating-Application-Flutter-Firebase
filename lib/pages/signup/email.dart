import 'package:dream_partner/login_screen.dart';
import 'package:dream_partner/pages/signup/profile/looking_for.dart';
import 'package:dream_partner/pages/signup/profile/profile_details.dart';
import 'package:dream_partner/pages/signup/verification.dart';
import 'package:dream_partner/theme/app_theme.dart';
import 'package:dream_partner/verifyemail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dream_partner/responsiveness.dart';
import 'package:google_fonts/google_fonts.dart';
class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<EmailPage> {
  bool _obscureText=true;
  bool _obscureText1=true;
  final _auth =FirebaseAuth.instance;
  final emailcontroller=TextEditingController();
  final passcontroller=TextEditingController();
  final confirmpasscontroller=TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: getheight(context),
        width: getwidth(context),
        child: SingleChildScrollView(
          
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: getheight(context) * 0.02),
                    child: Text(
                      "Dream Partner",
                      style: GoogleFonts.getFont('Clicker Script',
                          fontSize: getwidth(context) * 0.115,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.colors.darkPeach),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: getwidth(context) * 0.05, right: getwidth(context) * 0.05),
                  child: Image.asset('assets/images/login_vector.png',height: getheight(context)*0.35,width: getwidth(context),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: getwidth(context) * 0.05),
                  child: Text(
                    "Register Your Account",
                    style: GoogleFonts.dmSerifDisplay(fontSize: getwidth(context) * 0.055),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: getwidth(context) * 0.05),
                  child: Text(
                    "We will send you a link to get access to your account",
                    style: GoogleFonts.dmSerifDisplay(fontSize: getwidth(context) * 0.035),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: getheight(context) * 0.02, left: getwidth(context) * 0.05, right: getwidth(context) * 0.05),
                  child: TextFormField(
                    controller: emailcontroller,
                    validator: (value){
                      if(value!.isEmpty){
                          return 'Field required';
                      }
                      else if (!value.contains('@')) {
                        return 'Invalid email format';
                      }
                      else{
                        return null;

                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Email Address",
                      hintStyle: GoogleFonts.dmSerifDisplay(fontSize: getwidth(context) * 0.035),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(getwidth(context) * 0.05),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(getwidth(context) * 0.05),
                        borderSide: BorderSide(
                          color: AppTheme.colors.darkPeach,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: getheight(context) * 0.02, left: getwidth(context) * 0.05, right: getwidth(context) * 0.05),
                  child: TextFormField(
                    controller: passcontroller,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Field Required';
                      }
                      else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            _obscureText=!_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText?Icons.visibility_off:Icons.visibility,
                          color: AppTheme.colors.darkPeach,
                        ),
                      ),
                      hintText: "Password",
                      hintStyle: GoogleFonts.dmSerifDisplay(fontSize: getwidth(context) * 0.035),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(getwidth(context) * 0.05),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(getwidth(context) * 0.05),
                        borderSide: BorderSide(
                          color: AppTheme.colors.darkPeach,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: getheight(context) * 0.02, left: getwidth(context) * 0.05, right: getwidth(context) * 0.05),
                  child: TextFormField(
                    controller: confirmpasscontroller,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Field required';
                      }
                      if(passcontroller.text!=confirmpasscontroller.text){
                        return 'Password does not match ';
                      }
                      else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscureText1,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            _obscureText1=!_obscureText1;
                          });
                        },
                        icon: Icon(
                          _obscureText1?Icons.visibility_off:Icons.visibility,
                          color: AppTheme.colors.darkPeach,
                        ),
                      ),
                      hintText: "Confirm Password",
                      hintStyle: GoogleFonts.dmSerifDisplay(fontSize: getwidth(context) * 0.035),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(getwidth(context) * 0.05),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(getwidth(context) * 0.05),
                        borderSide: BorderSide(
                          color: AppTheme.colors.darkPeach,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(left:getheight(context) * 0.02,right:getheight(context) * 0.02,top:getheight(context) * 0.02),
                    child: Container(
                      width: getwidth(context)*0.45,
                      height: getheight(context)*0.05,
                      child: ElevatedButton(

                        onPressed: () async{
                          if(_formkey.currentState!.validate()) {
                              setState(() {
                                loading=true;
                              });
                              _auth.createUserWithEmailAndPassword(email: emailcontroller.text.toString(),
                                  password: passcontroller.text.toString()).then((value){
                                 Get.to(()=>VerifyEmailPage());
                              }).onError((error, stackTrace){
                                Get.snackbar('Error', error.toString());
                              });

                              setState(() {
                                loading=false;
                              });
                          }
                          else{
                                setState(() {
                                  loading=false;
                                });
                          }
                        },
                        child:loading? CircularProgressIndicator(color: Colors.white,): Text("Sign Up",style:
                          TextStyle(fontSize: 16),),
                        style: ElevatedButton.styleFrom(
                          primary: AppTheme.colors.darkPeach,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(getwidth(context) * 0.1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Alreday have an account?'),
                    TextButton(onPressed: (){


                     Get.offAll(()=>LoginPage());
                    }, child:
                    Text('Login',style: TextStyle(color: AppTheme.colors.darkPeach),))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
