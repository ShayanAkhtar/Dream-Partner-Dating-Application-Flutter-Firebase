import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final List<String> cardList = [
    'Card#1',
    'Card#2',
    'Card#3',
    'Card#4',
  ];

  void onCardSwipe(int index) {
    currentIndex.value = index;
  }

  void onReject() {
    // Handle the '×' button press
    currentIndex.value++;
  }

  void onLike() {
    // Handle the heart button press
    currentIndex.value++;
  }
}
