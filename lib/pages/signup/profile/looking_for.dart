import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dream_partner/pages/signup/profile/profile_controller.dart';
import 'package:dream_partner/responsiveness.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../login_screen.dart';
import '../../../theme/app_theme.dart';
import '../../dashboard/dashboard.dart';
import 'lookingfor_controller.dart';

class LookingFor extends StatefulWidget {

  LookingFor({super.key});

  @override
  State<LookingFor> createState() => _LookingForState();
}

class _LookingForState extends State<LookingFor> {
  var countryy;
  var statee;
  var cityy;
  bool loading = false;
  final ProfileController profileController = Get.put(ProfileController());
  final LookingForController lookController=Get.put(LookingForController());
  final users=FirebaseFirestore.instance.collection('UserDetails').doc(FirebaseAuth.instance.currentUser!.uid);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> addPrefernces(){
    return users.update({
      'PrefCast': lookController.selectedCast.value,
      'PrefCity': cityy.toString(),
      'PrefCountry': countryy.toString(),
      'PrefState': statee.toString(),
      'PrefGender': lookController.selectedGender.value,
      'PrefFamily Status': lookController.selectedFamilyStatus.value,
      'PrefProperty Status': lookController.selectedPropertyStatus.value,
      'PrefAgeRange From': lookController.fromAge.value,
      'PrefAgeRange To': lookController.toAge.value,
    });
  }
  @override
  Widget build(BuildContext context) {
    final LookingForController lookingForController =
    Get.put(LookingForController());

    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Get.width * 0.07,
                    right: Get.width * 0.07,
                    top: Get.width * 0.07),
                child: Image.asset('assets/images/lookingfor.png'),
              ),
              Padding(
                padding: EdgeInsets.only(left: Get.width * 0.03),
                child: Text(
                  'Select your preferences',
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: Get.width * 0.055,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: Get.width * 0.05,
                    right: Get.width * 0.05,
                    top: Get.width * 0.015),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cast Input (TextFormField)
                      Padding(
                        padding: EdgeInsets.only(top: getheight(context) * 0.015),
                        child: DropdownButtonFormField<String>(
                          value: lookingForController.selectedCast.value,
                          onChanged: (newValue) {
                            lookingForController.selectedCast.value = newValue!;
                          },
                          items: ['Khan','Malik','Rajpoot','Shaikh','Bhatti','Chaudhary','Cheema','Chughtai','Bajwa','Gujjar','Jutt','Mirza','Mian','Mughal','Naqvi'
                            ,'Qureshi','Raja','Khattak','Qazi','Niazi','Rizvi','Hussaini','Tanoli','Syed','Pasha','Butt']
                              .map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                          decoration: InputDecoration(
                            labelText: 'Caste',
                            labelStyle: TextStyle(
                              color: Colors
                                  .black, // Set label text color to your theme color
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(getwidth(context) * 0.05),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(getwidth(context) * 0.05),
                              borderSide: BorderSide(
                                color: AppTheme.colors.darkPeach,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // City Input (TextFormField)
                      Padding(
                        padding: EdgeInsets.only(top: getheight(context)*0.015),
                        child: CSCPicker(
                          onCountryChanged: (value){
                            countryy=value;
                          },
                          onStateChanged: (value){
                            statee=value;
                          },
                          onCityChanged: (value){
                            cityy=value;
                          },
                        ),
                      ),
                      // Gender Dropdown
                      Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.015),
                        child: DropdownButtonFormField<String>(
                          value: lookingForController.selectedGender.value,
                          onChanged: (newValue) {
                            lookingForController.setGender(newValue!);
                          },
                          items: [
                            'Male', // Unique value
                            'Female', // Unique value
                          ].map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(Get.width * 0.05),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(Get.width * 0.05),
                              borderSide: BorderSide(
                                color: AppTheme.colors.darkPeach,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.015),
                        child: DropdownButtonFormField<String>(
                          value: lookingForController.selectedFamilyStatus.value,
                          onChanged: (newValue) {
                            lookingForController.setFamilyStatus(newValue!);
                          },
                          items: [
                            'Upper Class',
                            'Middle Class',
                            'Lower Class',
                          ].map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                          decoration: InputDecoration(
                            labelText: 'Family Status',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(Get.width * 0.05),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(Get.width * 0.05),
                              borderSide: BorderSide(
                                color: AppTheme.colors.darkPeach,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.015),
                        child: DropdownButtonFormField<String>(
                          value:
                          lookingForController.selectedPropertyStatus.value,
                          onChanged: (newValue) {
                            lookingForController.setPropertyStatus(newValue!);
                          },
                          items: [
                            'Own House',
                            'Rented',
                          ].map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                          decoration: InputDecoration(
                            labelText: 'Property Status',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(Get.width * 0.05),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(Get.width * 0.05),
                              borderSide: BorderSide(
                                color: AppTheme.colors.darkPeach,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Age Range Slider
                      Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.015,left: Get.width * 0.02,bottom: Get.height * 0.015),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Age Range',
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: Get.width * 0.035,
                              ),
                            ),
                            Row(
                              children: [
                                // "From" Age Field
                                Expanded(
                                  child: TextFormField(
                                    initialValue: lookingForController
                                        .fromAge.value
                                        .toString(),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      lookingForController
                                          .setFromAge(int.tryParse(value) ?? 18);
                                    },
                                    decoration: InputDecoration(
                                      focusColor: AppTheme.colors.darkPeach,
                                      labelText: 'From',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppTheme.colors.darkPeach,
                                        ),
                                      ),
                                      labelStyle: TextStyle(
                                        color: AppTheme.colors.darkPeach,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16), // Add spacing between fields
                                // "To" Age Field
                                Expanded(
                                  child: TextFormField(
                                    initialValue: lookingForController.toAge.value
                                        .toString(),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      lookingForController
                                          .setToAge(int.tryParse(value) ?? 60);
                                    },
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppTheme.colors.darkPeach,
                                        ),
                                      ),
                                      labelText: 'To',
                                      labelStyle: TextStyle(
                                        color: AppTheme.colors.darkPeach,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Submit Button
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: Get.height * 0.02),
                          child: Container(
                            width: getwidth(context)*0.5,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppTheme.colors.darkPeach,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(Get.width * 0.1),
                                ),
                              ),
                              onPressed: () async{
                                setState(() {
                                  loading=true;
                                });
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading=true;
                                  });
                                  _formKey.currentState!.save();
                                  addPrefernces().then((value) {
                                    setState(() {
                                      loading=false;
                                    });
                                    Get.snackbar('Added', 'Preferences Added, Login To your Account');
                                    Get.offAll(() => LoginPage());
                                  }).onError((error, stackTrace) {
                                    setState(() {
                                      loading=false;
                                    });
                                    Get.snackbar('Error',error.toString() );
                                  });

                                }
                                else{
                                  setState(() {
                                    loading=false;
                                  });
                                }
                              },
                              child: loading?CircularProgressIndicator(color: Colors.white,):Text('Submit',style: TextStyle(fontSize: 18),),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
