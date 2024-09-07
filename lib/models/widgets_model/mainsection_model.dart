import 'package:flutter/material.dart';

class MainSectionModel {
  final String label;
  final String? routeName;
  final IconData? icon;
  final String? image;
  MainSectionModel(
      {required this.label, this.routeName, this.image, this.icon});
}
