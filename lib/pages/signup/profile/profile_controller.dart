import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final fullname= ''.obs;
  var fatherName = ''.obs;
  var state=''.obs;
  var age = ''.obs;
  var country = ''.obs;
  var province = 'Punjab'.obs;
  var city = ''.obs;
  var caste = 'Malik'.obs;
  var cnic = ''.obs;
  var qualification = 'High School'.obs;
  final dateOfBirth = Rx<DateTime?>(null);
  var sect = 'Sunni'.obs;
  var height = '5\'6"'.obs;
  var disability = 'No'.obs;
  var maritalStatus = 'Single'.obs;
  var noOfFamilyMembers = ''.obs;
  var brothers = '0'.obs;
  var sisters = '0'.obs;
  var marriedBrothers = '0'.obs;
  var marriedSisters = '0'.obs;
  var unmarriedBrothers = '0'.obs;
  var unmarriedSisters = '0'.obs;
  var fatherOccupation = ''.obs;
  var motherOccupation = ''.obs;
  var bio = ''.obs;
  var gender = 'Male'.obs;
  var familystatus= 'Upper Class'.obs;
  var propertystatus= 'Rented'.obs;
  var pictures = <String>[].obs; // List of image URLs

  // Custom validation for CNIC format (xxxxx-xxxxxxx-x)
  String? validateCNIC(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNIC is required';
    }
    final cnicRegExp = RegExp(r'^\d{5}-\d{7}-\d{1}$');
    if (!cnicRegExp.hasMatch(value)) {
      return 'Invalid CNIC format (e.g., xxxxx-xxxxxxx-x)';
    }
    return null;
  }

  // Add an image URL to the pictures list
  void addPicture(String imageUrl) {
    pictures.add(imageUrl);
  }

  // Remove an image URL from the pictures list
  void removePicture(int index) {
    if (index >= 0 && index < pictures.length) {
      pictures.removeAt(index);
    }
  }

}
