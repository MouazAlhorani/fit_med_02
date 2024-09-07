import 'package:file_picker/file_picker.dart';

pickfilFunc() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
  );

  if (result != null) {
    PlatformFile platformFile = result.files.single;
    return platformFile;
  }
}
