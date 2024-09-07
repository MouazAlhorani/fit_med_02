import 'package:flutter/material.dart';

class ChooseWeightUnitProvider extends ChangeNotifier {
  String _selected = "طن";
  String get selected => _selected;
  set selected(value) {
    _selected = value;
    notifyListeners();
  }
}
