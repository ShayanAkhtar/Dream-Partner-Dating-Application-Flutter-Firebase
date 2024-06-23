import 'package:get/get.dart';

class LookingForController extends GetxController {
  var selectedCast = 'Malik'.obs;
  var selectedCity = ''.obs;
  var selectedGender = 'Male'.obs;
  var selectedFamilyStatus = 'Upper Class'.obs; // Default family status
  var selectedPropertyStatus = 'Own House'.obs;
  var fromAge = 18.obs; // Initialize with a default "from" age
  var toAge = 60.obs;

  // Setters

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  void setCast(String cast) {
    selectedCast.value = cast;
  }

  void setCity(String city) {
    selectedCity.value = city;
  }

  void setFromAge(int age) {
    fromAge.value = age;
  }

  void setToAge(int age) {
    toAge.value = age;
  }

  void setFamilyStatus(String status) {
    selectedFamilyStatus.value = status;
  }

  void setPropertyStatus(String status) {
    selectedPropertyStatus.value = status;
  }
}
