import 'package:fit_medicine_02/controllers/providers/listwithboolean_provider.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget paragraph(
    List<bool> show, ShowMoreLessProvider showRead, element, index) {
  return element == null || element == "null" || element == ""
      ? const SizedBox()
      : Text.rich(element.length < 80
          ? TextSpan(children: [
              TextSpan(
                  text: element,
                  style: ThemeM.theme(color: Colors.black).textTheme.bodySmall)
            ])
          : !show[index]
              ? TextSpan(children: [
                  TextSpan(
                      text: element!.substring(0, 80),
                      style: ThemeM.theme(color: Colors.black)
                          .textTheme
                          .bodyMedium),
                  TextSpan(
                      text: " ..  عرض المزيد",
                      style: ThemeM.theme().textTheme.bodyMedium,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          showRead.togglepure(index);
                        })
                ])
              : TextSpan(children: [
                  TextSpan(
                      text: element,
                      style: ThemeM.theme(color: Colors.black)
                          .textTheme
                          .bodyMedium),
                  TextSpan(
                      text: " (عرض أقل) ",
                      style: ThemeM.theme().textTheme.bodyMedium,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          showRead.togglepure(index);
                        })
                ]));
}
