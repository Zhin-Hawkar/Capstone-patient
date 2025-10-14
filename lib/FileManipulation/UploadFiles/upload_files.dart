import 'package:file_picker/file_picker.dart';

class UploadFiles {
  static Future<List<PlatformFile>?> pickAndUploadFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'jpeg'],
      type: FileType.custom,
    );

    if (result != null) {
      result.files.single;
      return result.files;
    }
    return null;
  }
}
