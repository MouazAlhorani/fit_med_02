import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:flutter/material.dart';

appBarMZ(title, routeName) {
  return Container(
    margin: const EdgeInsets.all(6),
    decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
    child: Center(
      child: Hero(
        tag: routeName,
        child: Text(
          title,
          style: ThemeM.theme().textTheme.titleSmall,
        ),
      ),
    ),
  );
}
