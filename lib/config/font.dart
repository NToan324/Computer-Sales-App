import 'package:flutter/material.dart';

class FontSizes {
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 20.0;
  static const double extraLarge = 24.0;
  static const double xxl = 28.0;
  static const double xxxl = 32.0; // Bổ sung xxxl
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: FontSizes.xxxl, // Sửa lỗi tham chiếu
          fontWeight: FontWeight.bold),
      displayMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: FontSizes.xxl,
          fontWeight: FontWeight.bold),
      displaySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: FontSizes.extraLarge,
          fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: FontSizes.large),
      bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: FontSizes.medium),
      bodySmall: TextStyle(fontFamily: 'Poppins', fontSize: FontSizes.small),
      labelLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: FontSizes.large,
          fontWeight: FontWeight.w600),
      labelMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: FontSizes.medium,
          fontWeight: FontWeight.w500),
      labelSmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: FontSizes.small,
          fontWeight: FontWeight.w400),
    ),
  );
}
