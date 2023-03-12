import 'package:flutter/material.dart';

class ThemeColor {
  static Color khaki = const Color(0xFFE7D4C0);
  static Color salmon = const Color(0xFFE98973);
  static Color mintBlue = const Color(0xFF88B2CC);
  static Color blueGray = const Color(0xFF658EA9);
}

class TextStyles {
  static TextStyle appBarStyle =
      const TextStyle(fontSize: 34, fontFamily: 'Bangers');
  static TextStyle listileTitleTextStyle = const TextStyle(
    fontSize: 24,
    fontFamily: 'Bangers',
  );
  static TextStyle listileSubtitleTextStyle = TextStyle(
    fontSize: 16,
    fontFamily: 'Bangers',
    color: Colors.black.withOpacity(0.6),
  );
}
