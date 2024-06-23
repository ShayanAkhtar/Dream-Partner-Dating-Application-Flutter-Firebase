import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../likes/likes_controller.dart';
import 'home_controller.dart';

class HomeCustomCard extends StatelessWidget {
  final int index;
  final CardData cardData;

  HomeCustomCard({required this.index, required this.cardData});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final double cardHeight = Get.height * 0.6; // Card height based on screen height
    final double cardWidth = Get.width * 0.9; // Card width based on screen width

    return SizedBox(
      height: cardHeight,
      width: cardWidth,
      child: Card(

        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: [
            // Background Image
            Container(
              height: cardHeight,
              width: cardWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  cardData.backgroundImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Name of the Person
            Positioned(
              bottom: cardHeight * 0.05, // Adjust the position as needed
              left: cardWidth * 0.05, // Adjust the position as needed
              child: Text(
                cardData.name,
                style: TextStyle(
                  fontSize: cardWidth * 0.06, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                  color: AppTheme.colors.lightPeach,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
