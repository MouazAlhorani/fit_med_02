import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

textFormFieldMZ(
    {required String label,
    keyboardtype = TextInputType.text,
    TextEditingController? controller,
    required IconData suffixIcon,
    Function()? suffixFunction,
    Function(String)? submit,
    width = 300.0,
    obscuretext,
    readonly,
    lines,
    maxlength,
    FormFieldValidator? validate}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: SizedBox(
      // height: 60.0,
      width: width,
      child: TextFormField(
        maxLength: maxlength,
        onFieldSubmitted: submit,
        maxLines: lines ?? 1,
        readOnly: readonly ?? false,
        validator: validate,
        textAlign: TextAlign.center,
        style:
            ThemeM.theme(color: Colors.black, size: 20.0).textTheme.bodyMedium,
        keyboardType: keyboardtype,
        controller: controller,
        obscureText: obscuretext ?? false,
        decoration: InputDecoration(
            suffix: IconButton(
                onPressed: suffixFunction,
                icon: FaIcon(
                  suffixIcon,
                  size: 15,
                )),
            label: Text(
              label,
              style: ThemeM.theme(color: Colors.black).textTheme.labelMedium,
            ),
            focusedBorder:
                const OutlineInputBorder(borderSide: BorderSide(width: 1)),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(5, 5)))),
      ),
    ),
  );
}
