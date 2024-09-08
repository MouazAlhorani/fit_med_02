import 'package:flutter/material.dart';

class ProviderItemwithboolean {
  bool boolean = false;
  ProviderItemwithboolean({required this.boolean});
}

class TextFormFieldModel extends ProviderItemwithboolean {
  bool? obscuretext = false;
  final bool readonly;
  final String label;
  TextEditingController? controller;
  IconData? suffixIcon;
  final TextInputType? textInputType;
  FormFieldValidator? validate;
  Function()? suffixFunction;
  int? maxlines;
  final int? maxlength;
  TextFormFieldModel(
      {this.controller,
      this.obscuretext,
      this.maxlength,
      this.maxlines,
      this.suffixIcon,
      this.suffixFunction,
      this.validate,
      required this.label,
      this.readonly = false,
      this.textInputType = TextInputType.text})
      : super(boolean: obscuretext ?? false);
}

class ChooseItemSModel extends ProviderItemwithboolean {
  final String label;
  final IconData? icon;
  Function()? function;
  bool selected = false;
  ChooseItemSModel({
    required this.label,
    this.selected = false,
    this.icon,
    this.function,
  }) : super(boolean: selected);
}

class BottomBarItem extends ChooseItemSModel {
  final String? routeName;
  BottomBarItem(
      {required super.label,
      super.icon,
      super.selected,
      super.function,
      this.routeName});
}

class LocationModel extends ChooseItemSModel {
  int id;
  int price;
  DateTime? time;
  LocationModel(
      {required this.id,
      required super.label,
      super.selected,
      required this.price,
      this.time});
  factory LocationModel.fromjson({data}) {
    return LocationModel(
        id: data['id'],
        label: data['name'],
        price: data['delivery_price'],
        time: data['delivery_time'] == null ||
                data['delivery_time'] == "" ||
                data['delivery_time'] == "null"
            ? null
            : DateTime.parse(data['delivery_time']));
  }
}

class AnimalCategories extends ChooseItemSModel {
  int id;

  AnimalCategories({required this.id, required super.label});
  factory AnimalCategories.fromJson({data}) {
    return AnimalCategories(id: data['id'], label: data['name']);
  }
}
