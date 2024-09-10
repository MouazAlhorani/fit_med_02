import 'package:file_picker/file_picker.dart';

pickfilFunc({multifiles = false}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
      allowMultiple: multifiles);

  if (result != null) {
    List<PlatformFile> platformFile = result.files;
    return platformFile;
  }
}
