import "package:flutter/material.dart";

class AppColors {
  static const primaryColor = Color(0xFFFFFF);
  static const tombolLogin = Color.fromRGBO(255, 0, 0, 1.0); // Merah solid
  static const inputAbu = Color(0xD9D9D9);
  static const hitam = Colors.black;
}

class TextStyles {
  static TextStyle title = const TextStyle(
    fontFamily: 'Outfit',
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
    color: AppColors.hitam,
  );
}
