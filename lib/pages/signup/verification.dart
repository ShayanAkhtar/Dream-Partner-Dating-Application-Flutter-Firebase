import 'dart:async';

import 'package:dream_partner/pages/dashboard/dashboard.dart';
import 'package:dream_partner/pages/signup/profile/profile_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class VerificationPage extends StatefulWidget {

 VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
 bool isemailverified=false;
 Timer? timer;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
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
                "Check Your Email!",
                style:GoogleFonts.dmSerifDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("Resend"),
                style: ElevatedButton.styleFrom(
                  primary: AppTheme.colors.darkPeach,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

         },
        child: Icon(Icons.arrow_forward),
        backgroundColor: AppTheme.colors.darkPeach,
      )
    );
  }
}
