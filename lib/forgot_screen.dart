import 'package:dream_partner/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'responsiveness.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_partner/theme/app_theme.dart';
class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _auth =FirebaseAuth.instance;
  final emailcontroller=TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:Colors.white,
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
                  child: Image.asset('assets/images/login_vector.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: getwidth(context) * 0.05),
                  child: Text(
                    "Enter your Email Address",
                    style: GoogleFonts.dmSerifDisplay(fontSize: getwidth(context) * 0.055),
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
                SizedBox(
                  height: getheight(context)*0.005,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(left:getheight(context) * 0.02,right:getheight(context) * 0.02,top:getheight(context) * 0.02),
                    child: Container(
                      width: getwidth(context)*0.45,
                      height: getheight(context)*0.05,
                      child: ElevatedButton(

                        onPressed: () async{
                          setState(() {
                            loading=true;
                          });
                          if(_formkey.currentState!.validate()) {
                            setState(() {
                              loading=true;
                            });

                            _auth.sendPasswordResetEmail(email: emailcontroller.text).then((value){
                              Get.snackbar('Email Sent','Check your inbox to reset password');
                              Get.offAll(()=>LoginPage());
                            }).onError((error, stackTrace){
                            Get.snackbar('Error', error.toString());
                            });



                          }
                          else{
                            setState(() {
                              loading=false;
                            });
                          }
                        },
                        child:loading? CircularProgressIndicator(color: Colors.white,): Text("Continue",style:
                        TextStyle(fontSize: 18),),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
