import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_partner/login_screen.dart';
import 'package:dream_partner/pages/signup/profile/profile_controller.dart';
import 'package:dream_partner/responsiveness.dart';
import 'package:dream_partner/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../../update_profile.dart';

class ProfileDisplay extends StatefulWidget {
  ProfileDisplay({super.key});

  @override
  State<ProfileDisplay> createState() => _ProfileDisplayState();
}

class _ProfileDisplayState extends State<ProfileDisplay> {
  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      String uniqueFilename=DateTime.now().millisecond.toString();
      Reference store=FirebaseStorage.instance.ref().child('Images').child(uniqueFilename);
      await store.putFile(File(image.path));
      profilepicture=await store.getDownloadURL();
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
  bool loading=false;
  bool profileloading=false;
  var profilepicture;
  final nameController=TextEditingController();
  final fathernameController=TextEditingController();
  final Nationality=TextEditingController();
  final phoneController=TextEditingController();
  final cnic=TextEditingController();
  var disability;
  var material_status;
  var height;
  final BioController=TextEditingController();
  final ProfileController profileController = Get.put(ProfileController());
  final users=FirebaseFirestore.instance.collection('UserDetails').doc(FirebaseAuth.instance.currentUser!.uid);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DocumentReference userRef =
  FirebaseFirestore.instance.collection('UserDetails').doc(FirebaseAuth.instance.currentUser!.uid);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    users.get().then((value){
      setState(() {
        nameController.text=value.get('Full Name');
        fathernameController.text=value.get('Father Name');
        Nationality.text=value.get('Nationality');
        cnic.text=value.get('CNIC');
        disability=value.get('Disability');
        material_status=value.get('Marriage Status');
        height=value.get('Height');
        BioController.text=value.get('Bio');
        phoneController.text=value.get('Phone');
      });
    });
  }
  updateUser(){
    return users.update({
      'Full Name': nameController.text,
      'Father Name': fathernameController.text,
      'Nationality': Nationality.text,
      'CNIC': cnic.text,
      'Disability': disability,
      'Marriage Status': material_status,
      'Height':height,
      'Bio': BioController.text,
      'Phone':phoneController.text,
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height;
    final screenWidth = Get.width;

    return Scaffold(
      body:
      FutureBuilder<DocumentSnapshot>(
        future: userRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppTheme.colors.darkPeach,));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String fullName = userData['Full Name'];
            String email = userData['Email'];
            String profile = userData['Profile'];

            return Container(
                color: AppTheme.colors.white,
                height: screenHeight,
                width: screenWidth,
                child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Profile Details',
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.02),
                          child: Stack(
                            children: [
                              Container(
                                height: getwidth(context) * 0.3,
                                width: getwidth(context) * 0.3,
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.lightPeach,
                                  borderRadius: BorderRadius.circular(screenWidth * 0.3),
                                ),
                                child: ClipOval(
                                    child:profile!=null?Image(image: NetworkImage(profile),fit: BoxFit.cover,):
                                    Image(image: AssetImage('assets/images/default_image.png'),fit: BoxFit.cover,)
                                ),
                              ),
                              //                 Positioned(
                              //                   bottom: 0,
                              //                   right: 0,
                              //                   child: IconButton(
                              //                     icon: Icon(
                              //                       Icons.edit,
                              //                       color: AppTheme.colors.zeroPeach,
                              //                     ),
                              //                     onPressed: ()async {
                              //                       pickImage();
                              //                       // setState(() {
                              //                       //   profileloading=true;
                              //                       // });
                              //                       // ImagePicker _picker=ImagePicker();
                              //                       // XFile? file=await _picker.pickImage(source: ImageSource.gallery);
                              //                       // if(file==null) {
                              //                       //   Get.snackbar('No changes', 'No File is selected');}
                              //                       // else{
                              //                       //
                              //                       // String uniqueFilename=DateTime.now().millisecond.toString();
                              //                       // Reference store=FirebaseStorage.instance.ref().child('Images').child(uniqueFilename);
                              //                       //   store.putFile(File(file!.path));
                              //                       //   profilepicture=store.getDownloadURL();
                              //                       // }
                              // }
                              //                   ),
                              //                 ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: (){
                            Get.to(()=>UpdateProfile());
                          },
                          child: Container(
                            height: getheight(context)*0.05,
                            width: getwidth(context)*0.35,
                            decoration: BoxDecoration(
                              color: AppTheme.colors.mediumPeach,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text('Edit Profile',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.1,
                              right: screenWidth * 0.1,
                              top: screenHeight * 0.02),
                          child: Form(
                            key: _formKey, // Assign the form key
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Full Name
                                Padding(
                                  padding: EdgeInsets.only(top: screenHeight * 0.015),
                                  child: TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      hintText: 'Full Name',
                                      hintStyle: GoogleFonts.dmSerifDisplay(
                                          fontSize: screenWidth * 0.035),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                        borderSide: BorderSide(
                                          color: AppTheme.colors.darkPeach,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Full Name is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                // Father Name
                                Padding(
                                  padding: EdgeInsets.only(top: screenHeight * 0.015),
                                  child: TextFormField(
                                    controller: fathernameController,
                                    decoration: InputDecoration(
                                      hintText: 'Father Name',
                                      hintStyle: GoogleFonts.dmSerifDisplay(
                                          fontSize: screenWidth * 0.035),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                        borderSide: BorderSide(
                                          color: AppTheme.colors.darkPeach,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Father Name is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                // Nationality
                                Padding(
                                  padding: EdgeInsets.only(top: screenHeight * 0.015),
                                  child: TextFormField(
                                    controller: Nationality,
                                    decoration: InputDecoration(
                                      hintText: 'Nationality',
                                      hintStyle: GoogleFonts.dmSerifDisplay(
                                          fontSize: screenWidth * 0.035),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                        borderSide: BorderSide(
                                          color: AppTheme.colors.darkPeach,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Nationality is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: getheight(context) * 0.015),
                                  child: TextFormField(
                                      keyboardType: TextInputType.phone,
                                      controller: phoneController,
                                      decoration: InputDecoration(
                                        hintText: '+923459728974',
                                        hintStyle: TextStyle(color: Colors.black45),
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
                                      validator:(value){
                                        if(value!.isEmpty){
                                          Get.snackbar('Phone Number Required', 'Verify your phone number to continue');
                                        }
                                        if(!value.contains('+')){
                                          Get.snackbar('Error', '+ [Country Code] format not followed');
                                        }
                                      }
                                  ),
                                ),
                                // CNIC
                                Padding(
                                  padding: EdgeInsets.only(top: screenHeight * 0.015),
                                  child: TextFormField(
                                    controller: cnic,
                                    decoration: InputDecoration(
                                      hintText: 'CNIC (e.g., xxxxx-xxxxxxx-x)',
                                      hintStyle: GoogleFonts.dmSerifDisplay(
                                          fontSize: screenWidth * 0.035),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                        borderSide: BorderSide(
                                          color: AppTheme.colors.darkPeach,
                                        ),
                                      ),
                                    ),
                                    validator: profileController.validateCNIC,
                                    onSaved: (value) {
                                      profileController.cnic.value = value!;
                                    },
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.only(top: screenHeight * 0.015),
                                //   child: GestureDetector(
                                //     onTap: () async {
                                //       final selectedDate = await showDatePicker(
                                //         context: context,
                                //         initialDate:
                                //         profileController.dateOfBirth.value ??
                                //             DateTime.now(),
                                //         firstDate: DateTime(1900),
                                //         lastDate: DateTime.now(),
                                //         onDatePickerModeChange: (value) {
                                //
                                //         },
                                //       );
                                //       if (selectedDate != null) {
                                //         profileController.dateOfBirth.value =
                                //             selectedDate;
                                //       }
                                //     },
                                //     child: AbsorbPointer(
                                //       child: Obx(() {
                                //         return TextFormField(
                                //           decoration: InputDecoration(
                                //             suffixIcon:
                                //             Icon(Icons.calendar_today_outlined),
                                //             hintText: 'Date of Birth',
                                //             hintStyle:
                                //             GoogleFonts.dmSerifDisplay(fontSize: 14),
                                //             border: OutlineInputBorder(
                                //               borderRadius: BorderRadius.circular(
                                //                   screenWidth * 0.05),
                                //             ),
                                //             focusedBorder: OutlineInputBorder(
                                //               borderRadius: BorderRadius.circular(
                                //                   screenWidth * 0.05),
                                //               borderSide: BorderSide(
                                //                 color: AppTheme.colors.darkPeach,
                                //               ),
                                //             ),
                                //           ),
                                //           controller: DOB,
                                //           validator: (value) {
                                //             if (value == null || value.isEmpty) {
                                //               return 'Date of Birth is required';
                                //             }
                                //             return null;
                                //           },
                                //         );
                                //       }),
                                //     ),
                                //   ),
                                // ),

                                // Disability Dropdown
                                Padding(
                                  padding: EdgeInsets.only(top: screenHeight * 0.015),
                                  child: DropdownButtonFormField<String>(
                                    value: disability,
                                    onChanged: (newValue) {
                                      disability = newValue!;
                                    },
                                    items: ['No', 'Yes'].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      },
                                    ).toList(),
                                    decoration: InputDecoration(
                                      labelText: 'Disability',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                        borderSide: BorderSide(
                                          color: AppTheme.colors.darkPeach,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Marital Status Dropdown
                                Padding(
                                  padding: EdgeInsets.only(top: screenHeight * 0.015),
                                  child: DropdownButtonFormField<String>(
                                    value: material_status,
                                    onChanged: (newValue) {
                                      material_status = newValue!;
                                    },
                                    items: ['Single', 'Married', 'Divorced', 'Widow']
                                        .map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      },
                                    ).toList(),
                                    decoration: InputDecoration(
                                      labelText: 'Marital Status',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                        borderSide: BorderSide(
                                          color: AppTheme.colors.darkPeach,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Height Dropdown
                                Padding(
                                  padding: EdgeInsets.only(top: screenHeight * 0.015),
                                  child: DropdownButtonFormField<String>(
                                    value: height,
                                    onChanged: (newValue) {
                                      height = newValue!;
                                    },
                                    items: [
                                      '5\'0"',
                                      '5\'2"',
                                      '5\'4"',
                                      '5\'6"',
                                      '5\'8"',
                                      '6\'0"',
                                      '6\'2"',
                                      '6\'4"',
                                      '6\'8"',
                                    ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      },
                                    ).toList(),
                                    decoration: InputDecoration(
                                      labelText: 'Height',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                        borderSide: BorderSide(
                                          color: AppTheme.colors.darkPeach,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: screenHeight * 0.015),
                                  child: TextFormField(
                                    controller: BioController,
                                    maxLines: null,
                                    // Allows for multiple lines
                                    maxLength: 250,
                                    minLines: 3,
                                    // Set the maximum length to 250 characters
                                    decoration: InputDecoration(
                                      hintText: 'Bio (Up to 250 words)',
                                      hintStyle: GoogleFonts.dmSerifDisplay(fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(screenWidth * 0.05),
                                        borderSide: BorderSide(
                                          color: AppTheme.colors.darkPeach,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Bio is required';
                                      }
                                      if (value.length > 250) {
                                        return 'Bio should be no more than 250 words';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                // Submit Button
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                                    child: Container(
                                      width: getwidth(context)*0.5,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: AppTheme.colors.darkPeach,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(screenWidth * 0.1),
                                          ),
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            loading=true;
                                          });
                                          if (_formKey.currentState!.validate()) {
                                            setState(() {
                                              loading=false;

                                            });
                                            _formKey.currentState!.save();
                                            updateUser().then((value){
                                              Get.snackbar('Updated', 'Your Profile is updated successfully');
                                            }).onError((error, stackTrace){
                                              Get.snackbar('Error', error.toString());
                                            });

                                            // Perform further actions with the data...
                                          }
                                          else{
                                            setState(() {
                                              loading=false;
                                            });
                                          }
                                        },
                                        child: loading? CircularProgressIndicator(color: Colors.white,):Text('Update',style: TextStyle(fontSize: 18),),
                                      ),
                                    ),
                                  ),
                                ),
                                //Logout Button
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                                    child: Container(
                                      width: getwidth(context)*0.5,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: AppTheme.colors.inactiveColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(screenWidth * 0.1),
                                          ),
                                        ),
                                        onPressed: (){
                                          FirebaseAuth.instance.signOut().then((value){
                                            Get.snackbar('Logout', "You're Log out, See you again");
                                            Get.offAll(()=>LoginPage());
                                          }).onError((error, stackTrace){
                                            Get.snackbar('Error', error.toString());
                                          });
                                        },
                                        child: loading? CircularProgressIndicator(color: Colors.white,):Text('Logout',style: TextStyle(fontSize: 18),),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                )
            );
          } else {
            return Text('No user data found.');
          }
        },
      ),
    );
  }
}



