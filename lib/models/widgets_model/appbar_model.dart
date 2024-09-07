import 'package:flutter/material.dart';

class AppBarModel {
  final String title;
  final String? routeName;
  final IconData? icon;
  final Image? image;
  AppBarModel({required this.title, this.icon, this.image, this.routeName});
}
