import 'package:image_picker/image_picker.dart' as imagepicker;

pickImageCamera() async {
  final imagepicker.ImagePicker _picker = imagepicker.ImagePicker();
  imagepicker.XFile? image =
      await _picker.pickImage(source: imagepicker.ImageSource.camera);
  return image;
}
