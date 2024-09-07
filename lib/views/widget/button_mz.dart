import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Padding buttonMz(
    {padding,
    color,
    radius,
    elevation,
    label,
    labelColor,
    labelsize,
    icon,
    iconColor,
    iconSize,
    width,
    Function()? function}) {
  return Padding(
    padding: EdgeInsets.all(padding ?? 8.0),
    child: ElevatedButton.icon(
      iconAlignment: IconAlignment.end,
      style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.white70,
          shadowColor: Colors.grey,
          elevation: elevation ?? 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 15))),
      onPressed: function,
      label: SizedBox(
        width: width ?? 200.0,
        child: Text(
          label,
          style: ThemeM.theme(color: labelColor, size: labelsize)
              .textTheme
              .bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
      icon: FaIcon(
        icon,
        color: iconColor,
        size: iconSize ?? 20,
      ),
    ),
  );
}
