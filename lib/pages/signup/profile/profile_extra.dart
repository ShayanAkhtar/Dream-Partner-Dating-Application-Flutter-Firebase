import 'dart:io';
import 'package:dream_partner/addData.dart';
import 'package:dream_partner/pages/signup/profile/profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dream_partner/theme/app_theme.dart';
import 'package:dream_partner/responsiveness.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'looking_for.dart';
class ProfileExtra extends StatefulWidget {
  const ProfileExtra({super.key});

  @override
  State<ProfileExtra> createState() => _ProfileExtraState();
}

class _ProfileExtraState extends State<ProfileExtra> {
  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null)return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      String uniqueFilename=DateTime.now().millisecond.toString();
      Reference store=FirebaseStorage.instance.ref().child('Images').child(uniqueFilename);
      await store.putFile(File(image.path));
      imgurl=await store.getDownloadURL();
    } on PlatformException catch(e) {
      Get.snackbar('Error', e.toString());
    }
  }
  var imgurl;
  bool loading = false;

  final auth=FirebaseAuth.instance;
  final ProfileController profileController = Get.put(ProfileController());
  final AgeController=TextEditingController();
  final namecontroller=TextEditingController();
  final fathernameController=TextEditingController();
  final nationality=TextEditingController();
  final cnic=TextEditingController();
  final provincecontroller=TextEditingController();
  final citycontroller=TextEditingController();
  final sectcontroller=TextEditingController();
  final castecontroller=TextEditingController();
  final familymembers=TextEditingController();
  final fatherjob=TextEditingController();
  final motherjob=TextEditingController();
  final bioController=TextEditingController();
  final phonenumberController=TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final users=FirebaseFirestore.instance.collection('UserDetails').doc(FirebaseAuth.instance.currentUser!.uid);
  var countryy;
  var statee;
  var cityy;
  void updateSum() {
    int totalBrothers = int.parse(profileController.brothers.value);
    int totalMarried = int.parse(profileController.marriedBrothers.value);
    int totalUnmarried = int.parse(profileController.unmarriedBrothers.value);
    int totalsisters=int.parse(profileController.sisters.value);
    int totalmarriedsisters=int.parse(profileController.marriedSisters.value);
    int totalunmarriedsisters=int.parse(profileController.unmarriedBrothers.value);
    if (totalMarried + totalUnmarried != totalBrothers) {
      // Display a message if the sum is not equal
      Get.snackbar("Warning",
          "The sum of 'Married Brothers' and 'Unmarried Brothers' must be equal to the total number of brothers.");
    }
    if(totalmarriedsisters+totalunmarriedsisters!=totalsisters){
      Get.snackbar("Warning",
          "The sum of 'Married Sisters' and 'Unmarried Sisters' must be equal to the total number of sisters.");
    }
  }
  Future<void> addUser() async{
    return users.set({
      'Full Name': namecontroller.text,
      'Email': FirebaseAuth.instance.currentUser!.email,
      'Uid': FirebaseAuth.instance.currentUser!.uid,
      'Father Name': fathernameController.text,
      'Nationality': nationality.text,
      'Phone': phonenumberController.text,
      'CNIC': cnic.text,
      'DOB': profileController.dateOfBirth.value,
      'Disability': profileController.disability.value,
      'Marriage Status': profileController.maritalStatus.value,
      'Height': profileController.height.value,
      'Country': countryy.toString(),
      'Province': statee.toString(),
      'City': cityy.toString(),
      'Sect': sectcontroller.text,
      'Caste': profileController.caste.value,
      'Qualification': profileController.qualification.value,
      'Family Members': familymembers.text,
      'Brothers': profileController.brothers.value,
      'Sisters': profileController.sisters.value,
      'Married Sisters':profileController.marriedSisters.value,
      'Unmarried Sisters': profileController.unmarriedSisters.value,
      'Married Brothers': profileController.marriedBrothers.value,
      'Unmarried Brothers': profileController.unmarriedBrothers.value,
      'Father Occupation': fatherjob.text,
      'Mother Occupation': motherjob.text,
      'Bio': bioController.text,
      'Profile': imgurl,
      'Gender': profileController.gender.value,
      'Family Status':profileController.familystatus.value,
      'Property Status': profileController.propertystatus.value,
      'Age': AgeController.text,
      'PrefCast': "",
      'PrefCity': "",
      'PrefGender': "",
      'PrefFamily Status': "",
      'PrefProperty Status': "",
      'PrefAgeRange From': "",
      'PrefAgeRange To': "",
      'Liked Users': [],
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users.get().then((value){
      setState(() {
        imgurl=value.get('Profile');
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: Get.height,
        width: Get.width,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                        height: getwidth(context) * 0.3,
                        width: getwidth(context) * 0.3,
                        decoration: BoxDecoration(
                          color: AppTheme.colors.lightPeach,
                          borderRadius: BorderRadius.circular(getwidth(context) * 0.3),
                        ),
                        child: ClipOval(

                          child: image!=null? Container(
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          ):Image.asset(
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
                            Icons.camera_alt,
                            color: AppTheme.colors.zeroPeach,
                          ),
                          onPressed: ()async {
                            pickImage();
                            // ImagePicker _picker=ImagePicker();
                            // XFile? file=await _picker.pickImage(source: ImageSource.gallery);
                            // if(file==null) return;
                            // String uniqueFilename=DateTime.now().millisecond.toString();
                            //
                            // Reference store=FirebaseStorage.instance.ref().child('Images').child(uniqueFilename);
                            //
                            // try{
                            //   await store.putFile(File(file!.path));
                            //   imgurl=await store.getDownloadURL();
                            // }
                            // catch(error){
                            //
                            // }
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
                        ()=> Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name......
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            controller: namecontroller,
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
                            controller: fathernameController,
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
                            controller: nationality,
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
                            controller: cnic,
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
                          child: TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: phonenumberController,
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
                                 return 'Phone Number Required';
                                }
                                if(!value.contains('+')){
                                  return 'Must Follow +[Country Code] format';
                                }
                              }
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
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: DropdownButtonFormField<String>(
                            value: profileController.gender.value,
                            onChanged: (newValue) {
                              profileController.gender.value = newValue!;
                            },
                            items: ['Male','Female',]
                                .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            decoration: InputDecoration(
                              labelText: 'Gender',
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
                          child: DropdownButtonFormField<String>(
                            value: profileController.familystatus.value,
                            onChanged: (newValue) {
                              profileController.familystatus.value = newValue!;
                            },
                            items: ['Upper Class','Middle Class','Lower Class']
                                .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            decoration: InputDecoration(
                              labelText: 'Family Status',
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
                          child: DropdownButtonFormField<String>(
                            value: profileController.propertystatus.value,
                            onChanged: (newValue) {
                              profileController.propertystatus.value = newValue!;
                            },
                            items: ['Own House','Rented'].map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            decoration: InputDecoration(
                              labelText: 'Property Status',
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
                        // Padding(
                        //   padding: EdgeInsets.only(top: getheight(context) * 0.015),
                        //   child: TextFormField(
                        //     controller: provincecontroller,
                        //     decoration: InputDecoration(
                        //       hintText: 'Province',
                        //       hintStyle: TextStyle(
                        //         fontSize: getwidth(context) * 0.035,
                        //         color: Colors.black,
                        //       ),
                        //       border: OutlineInputBorder(
                        //         borderRadius:
                        //         BorderRadius.circular(getwidth(context) * 0.05),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius:
                        //         BorderRadius.circular(getwidth(context) * 0.05),
                        //         borderSide: BorderSide(
                        //           color: AppTheme.colors.darkPeach,
                        //         ),
                        //       ),
                        //     ),
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return 'Province is required';
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        // ),

                        // City


                        // Sect
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: DropdownButtonFormField<String>(
                            value: profileController.sect.value,
                            onChanged: (newValue) {
                              profileController.sect.value = newValue!;
                            },
                            items: ['Sunni','Shia','Others']
                                .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            decoration: InputDecoration(
                              labelText: 'Sect',
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

                        // Caste
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: DropdownButtonFormField<String>(
                            value: profileController.caste.value,
                            onChanged: (newValue) {
                              profileController.caste.value = newValue!;
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
                            keyboardType: TextInputType.number,
                            controller: familymembers,
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
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: AgeController,
                            decoration: InputDecoration(
                              hintText: 'Age',
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
                                return 'Age is required';
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
                            }, items: ['0', '1', '2', '3', '4', '5+']
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
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            initialValue:
                            profileController.marriedSisters.value,
                            onChanged: (value) {
                              profileController.marriedSisters.value = value;
                              updateSum();
                            },
                            decoration: InputDecoration(
                              labelText: 'Married Sisters',
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
                            profileController.unmarriedSisters.value,
                            onChanged: (value) {
                              profileController.unmarriedSisters.value = value;
                              updateSum();
                            },
                            decoration: InputDecoration(
                              labelText: 'UnMarried Sisters',
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
// Father Occupation
                        Padding(
                          padding: EdgeInsets.only(top: getheight(context) * 0.015),
                          child: TextFormField(
                            controller: fatherjob,
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
                            controller: motherjob,
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
                            controller: bioController,
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
                            child: Container(
                              width: getwidth(context)*0.5,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: AppTheme.colors.darkPeach,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(getwidth(context) * 0.1),
                                  ),
                                ),
                                onPressed: () async{
                                  setState(() {
                                    loading=true;
                                  });

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
                                  int totalBrothers = int.parse(
                                      profileController.brothers
                                          .value);
                                  int totalMarried = int.parse(
                                      profileController.marriedBrothers
                                          .value);
                                  int totalUnmarried = int.parse(
                                      profileController
                                          .unmarriedBrothers.value);

                                  if (totalMarried + totalUnmarried !=
                                      totalBrothers) {
                                    // Display a message if the sum is not equal
                                    Get.snackbar("Error",
                                        "The sum of 'Married Brothers' and 'Unmarried Brothers' must be equal to the total number of brothers.");
                                    setState(() {
                                      loading=false;
                                    });
                                  }
                                  int totalsisters=int.parse(profileController.sisters.value);
                                  int totalmarriedsisters=int.parse(profileController.marriedSisters.value);
                                  int totalunmarriedsisters=int.parse(profileController.unmarriedBrothers.value);
                                  if(totalmarriedsisters+totalunmarriedsisters!=totalsisters){
                                    Get.snackbar("Warning",
                                        "The sum of 'Married Sisters' and 'Unmarried Sisters' must be equal to the total number of sisters.");
                                    setState(() {
                                      loading=false;
                                    });

                                  }
                                  if (_formKey.currentState!
                                      .validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    _formKey.currentState!.save();


                                    addUser().then((value) {
                                      setState(() {
                                        loading=false;
                                        Get.snackbar("Record Added", 'Now select your preferences');
                                        Get.to(()=>LookingFor());
                                      });
                                    }).onError((error, stackTrace) {
                                      setState(() {
                                        loading = false;
                                        Get.snackbar(
                                            'Error', error.toString());
                                      });

                                    });
                                  }
                                  if(imgurl==null){
                                    Get.snackbar('Error', 'Profile picture required to continue');
                                    setState(() {
                                      loading=false;
                                    });
                                  }
                                  else {
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                },

                                child: loading? CircularProgressIndicator(color: Colors.white,):Text('Submit',style: TextStyle(fontSize: 18),),
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
      ),
    );
  }
}
