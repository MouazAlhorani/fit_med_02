import 'package:fit_medicine_02/models/service_model.dart';
import 'package:flutter/material.dart';

class AddtoCartlistProvider extends ChangeNotifier {
  AddtoCartlistProvider({required List<ServiceModel> list}) {
    _list = list;
  }
  List<ServiceModel> _list = [];
  List<ServiceModel> get list => _list;
  addProduct({required ServiceModel item, int count = 1}) {
    if (_list
        .any((r) => r.id == item.id && r.serviceType == item.serviceType)) {
      _list
          .where((r) => r.id == item.id && r.serviceType == item.serviceType)
          .first
          .count += count;
      print(item.serviceType);
    } else {
      _list.add(item);
      _list
          .where((r) => r.id == item.id && r.serviceType == item.serviceType)
          .first
          .count = count;
    }
    notifyListeners();
  }

  setProductcount(item, String count, ctx, controller) {
    if (int.tryParse(count) == null || int.parse(count) <= 0) {
      controller.text = _list
          .where((r) => r.id == item.id && r.serviceType == item.serviceType)
          .first
          .count
          .toString();
      return showDialog(
          context: ctx,
          builder: (_) {
            return const AlertDialog(
              content: Text("أدخل قيمة عددية صحيحة فوق الصفر"),
            );
          });
    } else {
      _list
          .where((r) => r.id == item.id && r.serviceType == item.serviceType)
          .first
          .count = int.parse(count);
    }

    notifyListeners();
  }

  getitemCount(item) {
    return _list
        .where((r) => r.id == item.id && r.serviceType == item.serviceType)
        .first
        .count;
  }

  getTotalPrice() {
    double total = 0;
    for (var i in _list) {
      if (i.price != null) {
        total += i.price! * i.count;
      }
    }
    return total;
  }

  removeProduct({required ServiceModel item, int count = 1}) {
    if (_list.contains(item)) {
      if (item.count > 1) {
        item.count -= count;
      }
    } else {
      _list.add(item);
    }

    notifyListeners();
  }

  removeProductCompletly({required ServiceModel item}) {
    _list.remove(item);
    notifyListeners();
  }

  reset() {
    _list.clear();
    notifyListeners();
  }
}
