import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fit_medicine_02/controllers/functions/pick_file.dart';
import 'package:fit_medicine_02/models/provider_itemwithboolean_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListwithbooleanProvider<T> extends ChangeNotifier {
  ListwithbooleanProvider({required List<T> list}) {
    _list = list;
  }
  List<T> _list = [];
  List<T> get list => _list;

  togglepure(index) {
    _list[index] = (_list[index] == true ? false : true) as T;
    notifyListeners();
  }

  choosepure(index) {
    for (var i = 0; i < _list.length; i++) {
      _list[i] = false as T;
    }
    _list[index] = true as T;
    notifyListeners();
  }

  togglePassword(TextFormFieldModel item) {
    item.obscuretext = !item.obscuretext!;
    item.suffixIcon =
        item.obscuretext! ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye;
    notifyListeners();
  }

  chooseItemS(ChooseItemSModel item) {
    item.selected = !item.selected;
    notifyListeners();
  }

  chooseItemformgroup(item, {routeName, ctx}) {
    for (var i in _list as List) {
      i.selected = false;
    }
    item.selected = !item.selected;
    notifyListeners();
  }

  pickfile({required TextFormFieldModel item, ctx}) async {
    if (item.controller!.text.isEmpty) {
      PlatformFile? file;
      try {
        file = await pickfilFunc();
      } catch (e) {}
      if (file != null) {
        item.controller!.text = file.path!;
      }
    } else {
      return showDialog(
          context: ctx,
          builder: (_) {
            return AlertDialog(
              content: Stack(
                children: [
                  Image.file(File(item.controller!.text)),
                  Positioned(
                    top: 30,
                    left: 10,
                    child: IconButton.filled(
                        onPressed: () {
                          item.controller!.clear();
                          Navigator.pop(ctx);
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 35,
                        )),
                  ),
                ],
              ),
            );
          });
    }

    notifyListeners();
  }
}

class LogInInputProvider extends ListwithbooleanProvider<TextFormFieldModel> {
  @override
  final List<TextFormFieldModel> list;
  LogInInputProvider(this.list) : super(list: list);
}

class RegisterAsVeteInputProvider
    extends ListwithbooleanProvider<TextFormFieldModel> {
  @override
  final List<TextFormFieldModel> list;
  RegisterAsVeteInputProvider(this.list) : super(list: list);
}

class RegisterAsBreederInputProvider
    extends ListwithbooleanProvider<TextFormFieldModel> {
  @override
  final List<TextFormFieldModel> list;
  RegisterAsBreederInputProvider(this.list) : super(list: list);
}

class ChooseAnimalTypesProvider
    extends ListwithbooleanProvider<AnimalCategories> {
  @override
  final List<AnimalCategories> list;
  ChooseAnimalTypesProvider(this.list) : super(list: list);
}

class BottomBarProvider extends ListwithbooleanProvider<BottomBarItem> {
  @override
  final List<BottomBarItem> list;
  BottomBarProvider(this.list) : super(list: list);
}

class LocationProvider extends ListwithbooleanProvider<LocationModel> {
  @override
  final List<LocationModel> list;
  LocationProvider(this.list) : super(list: list);
}

class ShowMoreLessProvider extends ListwithbooleanProvider<bool> {
  @override
  final List<bool> list;
  ShowMoreLessProvider(this.list) : super(list: list);
}

class WaitProvider extends ListwithbooleanProvider {
  @override
  final List<bool> list;
  WaitProvider(this.list) : super(list: list);
}
