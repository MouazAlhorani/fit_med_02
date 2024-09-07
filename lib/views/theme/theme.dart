import 'package:flutter/material.dart';

class ThemeM {
  static ThemeData theme({color, size, family}) =>
      ThemeData(useMaterial3: true).copyWith(
          textTheme: TextTheme(
        titleSmall: TextStyle(
            color: color ?? const Color(0XFF4F8500),
            fontSize: size ?? 20,
            fontFamily: family ?? "IBMPlexSansArabic"),
        titleMedium: TextStyle(
            color: color ?? const Color(0XFF4F8500),
            fontSize: size ?? 24,
            fontFamily: family ?? "IBMPlexSansArabic"),
        titleLarge: TextStyle(
            color: color ?? const Color(0XFF4F8500),
            fontSize: size ?? 28,
            fontFamily: family ?? "IBMPlexSansArabic",
            fontWeight: FontWeight.w900),

        //label
        labelSmall: TextStyle(
            color: color ?? const Color(0XFF4F8500),
            fontSize: size ?? 12,
            fontFamily: family ?? "IBMPlexSansArabic"),
        labelMedium: TextStyle(
            color: color ?? const Color(0XFF4F8500),
            fontSize: size ?? 16,
            fontFamily: family ?? "IBMPlexSansArabic"),
        labelLarge: TextStyle(
            color: color ?? const Color(0XFF4F8500),
            fontSize: size ?? 20,
            fontFamily: family ?? "IBMPlexSansArabic",
            fontWeight: FontWeight.w600),

        //labbodyel
        bodySmall: TextStyle(
            color: color ?? const Color(0XFF4F8500),
            fontSize: size ?? 14,
            fontFamily: family ?? "IBMPlexSansArabic"),
        bodyMedium: TextStyle(
            color: color ?? const Color(0XFF4F8500),
            fontSize: size ?? 16,
            fontFamily: family ?? "IBMPlexSansArabic"),
        bodyLarge: TextStyle(
            color: color ?? const Color(0XFF4F8500),
            fontSize: size ?? 18,
            fontFamily: family ?? "IBMPlexSansArabic",
            fontWeight: FontWeight.bold),
      ));
}
