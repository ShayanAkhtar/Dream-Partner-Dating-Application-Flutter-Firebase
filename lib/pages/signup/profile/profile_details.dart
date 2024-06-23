import 'package:dream_partner/pages/signup/profile/looking_for.dart';
import 'package:dream_partner/pages/signup/profile/profile_controller.dart';
import 'package:dream_partner/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dream_partner/responsiveness.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../dashboard/dashboard.dart';

class ProfileDetails extends StatelessWidget {
  ProfileDetails({super.key});

  final ProfileController profileController = Get.put(ProfileController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final users=FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid);
  void updateSum() {
    int totalBrothers = int.parse(profileController.brothers.value);
    int totalMarried = int.parse(profileController.marriedBrothers.value);
    int totalUnmarried = int.parse(profileController.unmarriedBrothers.value);

    if (totalMarried + totalUnmarried != totalBrothers) {
      // Display a message if the sum is not equal
      Get.snackbar("Warning",
          "The sum of 'Married Brothers' and 'Unmarried Brothers' must be equal to the total number of brothers.");
    }
  }

  // Future<void> addUser(){
  //   return users.set({
  //     'Full Name': profileController.fullname.value,
  //   }).then((value){
  //
  //   }).onError((error, stackTrace){
  //
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: Get.height,
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: getheight(context) * 0.02),
                child: Text(
                  'Profile Details',
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: getwidth(context) * 0.07,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: getheight(context) * 0.02),
                child: Stack(
                  children: [
                    Container(
                      height: getheight(context) * 0.15,
                      width: getwidth(context) * 0.3,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.lightPeach,
                        borderRadius: BorderRadius.circular(getwidth(context) * 0.1),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/default_image.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: AppTheme.colors.zeroPeach,
                        ),
                        onPressed: () {
                          // Add your edit button functionality here
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: getwidth(context) * 0.1,
                    right: getwidth(context) * 0.1,
                    top: getheight(context) * 0.02),
                child: Obx(
                  ()=> Form(
                    key: _formKey, // Assign the form key
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name

                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            onSaved: (value) {
                              profileController.fullname.value = value!;
                            },
                            decoration: InputDecoration(
                              hintText: 'Full Name',
                              hintStyle: GoogleFonts.dmSerifDisplay(
                                  fontSize: getwidth(context) * 0.035),
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
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Father Name',
                              hintStyle: GoogleFonts.dmSerifDisplay(
                                  fontSize: getwidth(context) * 0.035),
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
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Nationality',
                              hintStyle: GoogleFonts.dmSerifDisplay(
                                  fontSize: getwidth(context) * 0.035),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nationality is required';
                              }
                              return null;
                            },
                          ),
                        ),

                        // CNIC
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'CNIC (e.g., xxxxx-xxxxxxx-x)',
                              hintStyle: GoogleFonts.dmSerifDisplay(
                                  fontSize: getwidth(context) * 0.035),
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
                            validator: profileController.validateCNIC,
                            onSaved: (value) {
                              profileController.cnic.value = value!;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: GestureDetector(
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    profileController.dateOfBirth.value ??
                                        DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                profileController.dateOfBirth.value =
                                    selectedDate;
                              }
                            },
                            child: AbsorbPointer(
                              child: Obx(() {
                                return TextFormField(
                                  decoration: InputDecoration(
                                    suffixIcon:
                                        Icon(Icons.calendar_today_outlined),
                                    hintText: 'Date of Birth',
                                    hintStyle:
                                        GoogleFonts.dmSerifDisplay(fontSize: 14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          getwidth(context) * 0.05),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          getwidth(context) * 0.05),
                                      borderSide: BorderSide(
                                        color: AppTheme.colors.darkPeach,
                                      ),
                                    ),
                                  ),
                                  controller: TextEditingController(
                                    text: profileController.dateOfBirth.value !=
                                            null
                                        ? DateFormat('yyyy-MM-dd').format(
                                            profileController.dateOfBirth.value!)
                                        : '',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Date of Birth is required';
                                    }
                                    return null;
                                  },
                                );
                              }),
                            ),
                          ),
                        ),

                        // Disability Dropdown
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: DropdownButtonFormField<String>(
                            value: profileController.disability.value,
                            onChanged: (newValue) {
                              profileController.disability.value = newValue!;
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

                        // Marital Status Dropdown
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: DropdownButtonFormField<String>(
                            value: profileController.maritalStatus.value,
                            onChanged: (newValue) {
                              profileController.maritalStatus.value = newValue!;
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

                        // Height Dropdown
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: DropdownButtonFormField<String>(
                            value: profileController.height.value,
                            onChanged: (newValue) {
                              profileController.height.value = newValue!;
                            },
                            items: [
                              '4\'0"',
                              '4\'2"',
                              '4\'4"',
                              '4\'6"',
                              '4\'8"',
                              '5\'0"',
                              '5\'2"',
                              '5\'4"',
                              '5\'6"',
                              '5\'8"',
                              '6\'0"',
                              '6\'2"',
                              '6\'4"',
                              '6\'6"',
                              '6\'8"',
                              '7\'0"',
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
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Province',
                              hintStyle: TextStyle(
                                fontSize: getwidth(context) * 0.035,
                                color: Colors.black,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Province is required';
                              }
                              return null;
                            },
                          ),
                        ),

                        // City
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'City',
                              hintStyle: TextStyle(
                                fontSize: getwidth(context) * 0.035,
                                color: Colors.black,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'City is required';
                              }
                              return null;
                            },
                          ),
                        ),

                        // Sect
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Sect',
                              hintStyle: TextStyle(
                                fontSize: getwidth(context) * 0.035,
                                color: Colors.black,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Sect is required';
                              }
                              return null;
                            },
                          ),
                        ),

                        // Caste
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Caste',
                              hintStyle: TextStyle(
                                fontSize: getwidth(context) * 0.035,
                                color: Colors.black,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Caste is required';
                              }
                              return null;
                            },
                          ),
                        ),

                        // Qualification Dropdown
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: DropdownButtonFormField<String>(
                            value: profileController.qualification.value,
                            onChanged: (newValue) {
                              profileController.qualification.value = newValue!;
                            },
                            items: [
                              'High School',
                              'Bachelor\'s Degree',
                              'Master\'s Degree',
                              'Ph.D.',
                              'Other'
                            ].map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value, // Ensure each value is unique
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            decoration: InputDecoration(
                              labelText: 'Qualification',
                              labelStyle: TextStyle(
                                fontSize: getwidth(context) * 0.035,
                                color: Colors.black,
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

                        // No of Family Members
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'No of Family Members',
                              hintStyle: TextStyle(
                                fontSize: getwidth(context) * 0.035,
                                color: Colors.black,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'No of Family Members is required';
                              }
                              return null;
                            },
                          ),
                        ),

                        // Brothers Dropdown
                        // Brothers Dropdown
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: DropdownButtonFormField<String>(
                            value: profileController.brothers.value,
                            onChanged: (newValue) {
                              profileController.brothers.value = newValue!;
                              // When the user changes the number of brothers, reset the values of Married and Unmarried Brothers
                              profileController.marriedBrothers.value = '0';
                              profileController.unmarriedBrothers.value = '0';
                              // Update the sum
                              updateSum();
                            },
                            items: [
                              '0',
                              '1',
                              '2',
                              '3',
                              '4',
                              '5',
                              '6',
                              '7',
                              '8',
                              '9',
                              '10+'
                            ].map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            decoration: InputDecoration(
                              labelText: 'Brothers',
                              labelStyle: TextStyle(
                                color: Colors
                                    .black, // Set label text color to your theme color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getwidth(context) * 0.05),
                                borderSide: BorderSide(
                                  color: AppTheme.colors.darkPeach,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getwidth(context) * 0.05),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            initialValue: profileController.marriedBrothers.value,
                            onChanged: (value) {
                              profileController.marriedBrothers.value = value;
                              updateSum();
                            },
                            decoration: InputDecoration(
                              labelText: 'Married Brothers',
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getwidth(context) * 0.05),
                                borderSide: BorderSide(
                                  color: AppTheme.colors.darkPeach,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getwidth(context) * 0.05),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            initialValue:
                                profileController.unmarriedBrothers.value,
                            onChanged: (value) {
                              profileController.unmarriedBrothers.value = value;
                              updateSum();
                            },
                            decoration: InputDecoration(
                              labelText: 'Unmarried Brothers',
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getwidth(context) * 0.05),
                                borderSide: BorderSide(
                                  color: AppTheme.colors.darkPeach,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getwidth(context) * 0.05),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: DropdownButtonFormField<String>(
                            value: profileController.sisters.value,
                            onChanged: (newValue) {
                              profileController.sisters.value = newValue!;
                            },
                            items: ['0', '1', '2', '3', '4', '5+']
                                .map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            decoration: InputDecoration(
                              labelText: 'Sisters',
                              labelStyle: TextStyle(
                                color: Colors
                                    .black, // Set label text color to your theme color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getwidth(context) * 0.05),
                                borderSide: BorderSide(
                                  color: AppTheme.colors.darkPeach,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getwidth(context) * 0.05),
                              ),
                            ),
                          ),
                        ),

// Father Occupation
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Field required';
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Father's Occupation",
                              hintStyle: TextStyle(
                                fontSize: getwidth(context) * 0.035,
                                color: Colors.black,
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
                            onSaved: (value) {
                              profileController.fatherOccupation.value = value!;
                            },
                          ),
                        ),

// Mother Occupation
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Field required';
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Mother's Occupation",
                              hintStyle: TextStyle(
                                fontSize: getwidth(context) * 0.035,
                                color: Colors.black,
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
                            onSaved: (value) {
                              profileController.motherOccupation.value = value!;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
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
                            padding: EdgeInsets.only(bottom: getheight(context) * 0.02),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppTheme.colors.darkPeach,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(getwidth(context) * 0.1),
                                ),
                              ),
                              onPressed: () async{
                                // int totalBrothers =
                                //     int.parse(profileController.brothers.value);
                                // int totalMarried = int.parse(
                                //     profileController.marriedBrothers.value);
                                // int totalUnmarried = int.parse(
                                //     profileController.unmarriedBrothers.value);
                                //
                                // if (totalMarried + totalUnmarried !=
                                //     totalBrothers) {
                                //   Get.snackbar("Error",
                                //       "The sum of 'Married Brothers' and 'Unmarried Brothers' must be equal to the total number of brothers.");
                                // } else {
                                int totalBrothers = int.parse(profileController.brothers.value);
                                int totalMarried = int.parse(profileController.marriedBrothers.value);
                                int totalUnmarried = int.parse(profileController.unmarriedBrothers.value);

                                if (totalMarried + totalUnmarried != totalBrothers) {
                                  // Display a message if the sum is not equal
                                  Get.snackbar("Error", "The sum of 'Married Brothers' and 'Unmarried Brothers' must be equal to the total number of brothers.");
                                }
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  Get.to(() => LookingFor() );
                                }
                              },
                              child: Text('Submit'),
                            ),
                          ),
                        ),
                      ],
                    ),
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

// class AdditionalInfoScreen extends StatelessWidget {
//   final ProfileController profileController = Get.put(ProfileController());
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     final getheight(context) = Get.height;
//     final getwidth(context) = Get.width;
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//
//         },
//         child: Icon(Icons.arrow_forward),
//         backgroundColor: AppTheme.colors.darkPeach,
//       ),
//       body: Container(
//         color: AppTheme.colors.white,
//         height: getheight(context),
//         width: getwidth(context),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(top: getheight(context) * 0.02),
//                 child: Text(
//                   'Additional Info',
//                   style: GoogleFonts.dmSerifDisplay(
//                     fontSize: getwidth(context) * 0.07,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                   left: getwidth(context) * 0.1,
//                   right: getwidth(context) * 0.1,
//                   top: getheight(context) * 0.02,
//                 ),
//                 child: Form(
//                   key: _formKey, // Assign the form key
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Province
//
//
//                       // Submit Button
//                       Center(
//                         child: Padding(
//                           padding: EdgeInsets.only(bottom: getheight(context) * 0.02),
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               primary: AppTheme.colors.darkPeach,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(getwidth(context) * 0.1),
//                               ),
//                             ),
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 _formKey.currentState!.save();
//                                 // Perform further actions with the data...
//                               }
//                             },
//                             child: Text('Submit'),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
