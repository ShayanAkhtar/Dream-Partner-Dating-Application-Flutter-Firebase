import 'package:get/get.dart';

class LikesController extends GetxController {
  var cards = <CardData>[].obs;
  var currentIndex = 0.obs;

  void addCard(CardData card) {
    cards.add(card);
  }

  void onReject() {
    // Handle the 'x' button press
    currentIndex++;
  }

  void onLike() {
    // Handle the heart button press
    currentIndex++;
  }
}

class CardData {
  final String backgroundImage;
  final String name;

  CardData({
    required this.backgroundImage,
    required this.name,
  });
}
