import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int _count = 1;
  int get count => _count;
  addone() {
    _count++;
    notifyListeners();
  }

  minusone() {
    if (_count > 1) {
      _count--;
    }
    notifyListeners();
  }

  setcount(value, controller, item, ctx) {
    if (int.tryParse(value) == null || int.parse(value) < 1) {
      controller.text = item.count.toString();
      return showDialog(
          context: ctx,
          builder: (_) {
            return const AlertDialog(
              content: Text("أدخل قيمة عددية صحيحة فوق الصفر"),
            );
          });
    } else {
      _count = int.parse(value);
    }
    notifyListeners();
  }
}
