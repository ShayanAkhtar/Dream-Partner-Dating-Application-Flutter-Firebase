import 'package:dream_partner/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'likes_controller.dart';

class CustomCard extends StatelessWidget {
  final CardData cardData;
  final Function() onReject;
  final Function() onLike;

  const CustomCard({
    required this.cardData,
    required this.onReject,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          // Background Image
          Image.asset(
            cardData.backgroundImage,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Name of the Person
          Positioned(
            bottom: 50.0,
            left: 8.0,
            child: Text(
              cardData.name,
              style: GoogleFonts.almarai(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppTheme.colors.white, // Replace with your theme color
              ),
            ),
          ),
          // Buttons
          Positioned(
            bottom: 3.0,
            left: 8.0,
            right: 8.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onReject,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppTheme.colors.mediumPeach, // Replace with your theme color
                  ),
                ),
                ElevatedButton(
                  onPressed: onLike,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Icon(
                    Icons.favorite_outline_rounded,
                    color: AppTheme.colors.mediumPeach, // Replace with your theme color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );


  }
}
