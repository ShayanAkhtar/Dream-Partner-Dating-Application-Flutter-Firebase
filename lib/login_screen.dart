import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_partner/forgot_screen.dart';
import 'package:dream_partner/pages/dashboard/dashboard.dart';
import 'package:dream_partner/pages/signup/email.dart';
import 'package:dream_partner/verifyemail.dart';
import 'package:flutter/material.dart';
import 'responsiveness.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_partner/theme/app_theme.dart';
import 'package:get/get.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _firestore=FirebaseFirestore.instance.collection('UserDetails');
  bool _obscureText=true;
  final _auth =FirebaseAuth.instance;
  final emailcontroller=TextEditingController();
  final passcontroller=TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  bool emailExists = false;
  Future<bool> EmailCheck(String email) async {
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('UserDetails');
    try {
      QuerySnapshot querySnapshot = await usersCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          // Access the 'email' field from the Firestore document
          String userEmail = doc.get('Email');

          if (userEmail == email) {
            emailExists = true;
          }
        });
      }
    } catch (e) {
      print("Error checking email existence: $e");
    }

    return emailExists;
  }
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
                    "Login to your account",
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
                SizedBox(
                  height: getheight(context)*0.005,
                ),
                Padding(
                  padding: EdgeInsets.only(right: getwidth(context)*0.05),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: (){
                      Get.to(()=>ForgotScreen());
                    }, child:
                    Text('Forgot Password?',style: TextStyle(color: AppTheme.colors.darkPeach),)),
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
                          setState(() {
                            loading=true;
                          });
                          if(_formkey.currentState!.validate()) {
    setState(() {
    loading=true;
    });
    EmailCheck(emailcontroller.text);

      _auth.signInWithEmailAndPassword(email: emailcontroller.text,
          password: passcontroller.text).then((value){
            setState(() {
              loading=false;
            });
            if(emailExists==true) {
              setState(() {
                loading=false;
              });
              Get.snackbar('Welcome Back<3', '');
              Get.offAll(() => MyDashBoard());
            }
            else{
              setState(() {
                loading=false;
              });
              Get.snackbar('Profile Details Incomplete', 'Complete your profile setup and continue');
              Get.to(()=>VerifyEmailPage());
            }
      }).onError((error, stackTrace){
        setState(() {
          loading=false;
        });
        Get.snackbar('Error', error.toString());
      });

    // else{
    //   setState(() {
    //     loading=false;
    //
    //   });
    //
    //   // _auth.signInWithEmailAndPassword(email: emailcontroller.text, password: passcontroller.text)
    //   // .then((value) {
    //   //
    //   // }).onError((error, stackTrace){
    //   //   Get.snackbar('Error', error.toString());
    //   // });
    //
    //
    // }
    // _auth.signInWithEmailAndPassword(email: emailcontroller.text, password:
    //     passcontroller.text
    // ).then((value){
    //   if(FirebaseAuth.instance.currentUser!.uid== _firestore.doc().id){
    //     setState(() {
    //       loading=false;
    //     });
    //     Get.offAll(()=>MyDashBoard());
    //
    //   }
    //
    // }).onError((error, stackTrace) {
    //   Get.snackbar('Error', error.toString());
    // });
    // if(FirebaseAuth.instance.currentUser!=null &&  _firestore
    //     .doc()
    //     .id == FirebaseAuth.instance.currentUser!.uid){
    //   _auth.signInWithEmailAndPassword(email: emailcontroller.text,
    //       password: passcontroller.text).then((value) {
    //     setState(() {
    //       loading = false;
    //     });
    //     Get.snackbar('Login Successful', 'Welcome Back <3');
    //     Get.to(() => MyDashBoard());
    //   }).onError((error, stackTrace) {
    //     setState(() {
    //       loading = false;
    //     });
    //     Get.snackbar('Error', error.toString());
    //   });
    // }
    // else{
    // if(
    // _firestore
    //     .doc()
    //     .id == FirebaseAuth.instance.currentUser!.uid ) {
    //
    //
    // _auth.signInWithEmailAndPassword(email: emailcontroller.text,
    // password: passcontroller.text).then((value) {
    // setState(() {
    // loading = false;
    // });
    // Get.snackbar('Login Successful', 'Welcome Back <3');
    // Get.to(() => MyDashBoard());
    // }).onError((error, stackTrace) {
    // setState(() {
    // loading = false;
    // });
    // Get.snackbar('Error', error.toString());
    // });
    // }
    //
    // else if(_firestore
    //     .doc()
    //     .id == FirebaseAuth.instance.currentUser!.uid){
    // Get.snackbar(
    // 'Error', 'Signup Again and complete your profile setup to continue');
    // Get.offAll(() => EmailPage());
    // setState(() {
    // loading = false;
    // });
    // }
    //
    // else{
    //     print('No operation');
    //   setState(() {
    //     loading=false;
    //   });
    //
    // }
    // }

    }



                          else{
                            setState(() {
                              loading=false;
                            });
                          }
                        },
                        child:loading? CircularProgressIndicator(color: Colors.white,): Text("Login",style:
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Need an account?'),
                    TextButton(onPressed: (){
                      Get.to(()=>EmailPage());
                    }, child:
                    Text('SignUp',style: TextStyle(color: AppTheme.colors.darkPeach),))
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
