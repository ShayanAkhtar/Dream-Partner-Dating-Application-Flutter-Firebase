import 'dart:async';
import 'package:dream_partner/pages/signup/profile/profile_details.dart';
import 'package:dream_partner/pages/signup/profile/profile_extra.dart';

import 'theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_partner/pages/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'responsiveness.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {

  bool isverified=false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isverified=FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isverified){
      sendVerificationEmail();

      timer=Timer.periodic(Duration(seconds: 3), (_)=>checkEmailVerify()
      );
    }

  }
  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerify() async{
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isverified=FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isverified){
      timer?.cancel();
    }
}
  Future sendVerificationEmail() async{
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    }
    catch(e){
      Get.snackbar('Error', e.toString());
    }
  }
  @override

  Widget build(BuildContext context)
    => isverified?ProfileExtra():Scaffold(
        body: Container(
            color: AppTheme.colors.white,
            height: Get.height,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05),
                  child: Image.asset('assets/images/checkemail.png'),
                ),
                Text(
                  "Check Your Email's Inbox",
                  style:GoogleFonts.dmSerifDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: getheight(context)*0.02,
                ),
                Container(
                    width: getwidth(context)*0.5,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async{
                      sendVerificationEmail().then((value){
                        Get.snackbar('Email Sent', "Check your Email's Inbox");
                      }).onError((error, stackTrace){
                        Get.snackbar('Error', error.toString());
                      });
                    },
                    child: Text("Resend",style: TextStyle(fontSize: 18),),
                    style: ElevatedButton.styleFrom(
                      primary: AppTheme.colors.darkPeach,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            )),
    );
  }

