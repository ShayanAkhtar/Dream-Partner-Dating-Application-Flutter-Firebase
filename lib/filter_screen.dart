import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dream_partner/pages/dashboard/dashboard.dart';
import 'package:dream_partner/responsiveness.dart';
import 'package:dream_partner/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  var countryy;
  var statee;
  var cityy;
  var castt;
  final users=FirebaseFirestore.instance.collection('UserDetails').doc(FirebaseAuth.instance.currentUser!.uid);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final castController=TextEditingController();
  final cityController=TextEditingController();
  var genderController;
  var familystatusController;
  var propertystatusController;
  var agefromController=TextEditingController();
  var agetoController=TextEditingController();
  bool loading=false;
  updatePref(){
    return users.update({
      'PrefCast': castt.toString(),
      'PrefCity': cityy.toString(),
      'PrefCountry': countryy.toString(),
      'PrefState': statee.toString(),
      'PrefGender': genderController,
      'PrefFamily Status': familystatusController,
      'PrefProperty Status': propertystatusController,
      'PrefAgeRange From': agefromController.text.toString(),
      'PrefAgeRange To':agetoController.text.toString(),
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users.get().then((value){
      setState(() {
        castt=value.get('PrefCast');
        cityController.text=value.get('PrefCity');
        genderController=value.get('PrefGender');
        familystatusController=value.get('PrefFamily Status');
        propertystatusController=value.get('PrefProperty Status');
        agefromController.text=value.get('PrefAgeRange From');
        agetoController.text=value.get('PrefAgeRange To');

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          toolbarHeight: 100,
          elevation: 0,
          backgroundColor: AppTheme.colors.darkPeach,
          title: Text('Filter',style: TextStyle(color: AppTheme.colors.white,fontSize: 20),),
        ),
        body: Container(
          width: getwidth(context),
          height: getheight(context),
          child: SingleChildScrollView(
            child: Padding(
              padding:EdgeInsets.only(left: getwidth(context)*0.1,right: getwidth(context)*0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getheight(context)*0.05,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Filter Your Preferences',style: TextStyle(
                          fontSize: 18,fontWeight: FontWeight.bold
                      ),),
                      TextButton(onPressed: (){
                        users.update({
                          'PrefCity':"",
                        });
                        Get.snackbar('Updated', 'Preferences Cleared');
                        Get.offAll(()=>MyDashBoard());
                      }, child:
                      Text(
                        'Clear all',style: TextStyle(color: Colors.red),
                      ))
                    ],
                  )
,
                  SizedBox(height: getheight(context)*0.02,),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cast Input (TextFormField)
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: DropdownButtonFormField<String>(
                            value: castt,
                            onChanged: (newValue) {
                              castt = newValue!;
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
                            value: genderController,
                            onChanged: (newValue) {
                              genderController=newValue!;
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
                            value: familystatusController,
                            onChanged: (newValue) {
                              familystatusController=newValue!;
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
                            propertystatusController,
                            onChanged: (newValue) {
                              propertystatusController=newValue!;
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
                                      controller: agefromController,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(width: 16), // Add spacing between fields
                                  // "To" Age Field
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: agetoController,
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
                        SizedBox(height: getheight(context)*0.02,),
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
                                    updatePref().then((value) {
                                      setState(() {
                                        loading=false;
                                      });
                                      Get.snackbar('Updated', 'Preferences Updated, Enjoy your Day :)');
                                      Get.to(() => MyDashBoard());
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
                                child: loading?CircularProgressIndicator(color: Colors.white,):Text('Apply',style: TextStyle(fontSize: 18),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
