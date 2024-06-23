import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_partner/login_screen.dart';
import 'package:dream_partner/pages/dashboard/dashboard.dart';
import 'package:dream_partner/responsiveness.dart';
import 'package:dream_partner/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../signup/email.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _firestore=FirebaseFirestore.instance.collection('UserDetails');
  Future<void> _preloadAssets(BuildContext context) async {
    await precacheImage(AssetImage('assets/images/checkemail.png'), context);
    await precacheImage(AssetImage('assets/images/default_image.png'), context);
    await precacheImage(AssetImage('assets/images/login_vector.png'), context);
    await precacheImage(AssetImage('assets/images/logo.png'), context);
    await precacheImage(AssetImage('assets/images/lookingfor.png'), context);

    // await precacheImage(AssetImage('assets/images/card0.jpg'), context);
    // await precacheImage(AssetImage('assets/images/card1.jpg'), context);
    // await precacheImage(AssetImage('assets/images/card2.jpg'), context);
    // await precacheImage(AssetImage('assets/images/card3.jpg'), context);
  }

  @override
  Widget build(BuildContext context) {
    _preloadAssets(context);
    _loadDataAndNavigate();

    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: AppTheme.colors.darkPeach,
            ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: 0.8, // Adjust as needed
              child: Text(
                "Powered by innovative startups",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.colors.darkPeach,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                      ),
              ),
            ),),
        )
          ],
        ),
      ),
    );
  }

  // Load data or perform initialization and navigate to the next screen
  void _loadDataAndNavigate() {
    Future.delayed(Duration(seconds: 3), () {
         Get.off(() =>
         FirebaseAuth.instance.currentUser != null &&
             _firestore
                 .doc(FirebaseAuth.instance.currentUser!.uid)
                 .id == FirebaseAuth.instance.currentUser!.uid
             ? MyDashBoard()
             : LoginPage());
       }// Replace with your desired destination
    );
  }


  // deleteuser(){
  //   if(FirebaseAuth.instance.currentUser!.uid !=  _firestore
  //       .doc()
  //       .id){
  //     FirebaseAuth.instance.currentUser!.delete();
  //     Get.offAll(()=>LoginPage());
  //   }
  // }
}
