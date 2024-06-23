import 'package:dream_partner/firebase_options.dart';
import 'package:dream_partner/pages/signup/email.dart';
import 'package:dream_partner/pages/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:google_fonts/google_fonts.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        title: 'Dream Partner',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/', // Ensure this is set to your SplashScreen route
        getPages: [
          GetPage(name: '/', page: () => SplashScreen()), // Define SplashScreen as the initial route
          // Define other routes here
        ],
      ),
    );
  }
}

