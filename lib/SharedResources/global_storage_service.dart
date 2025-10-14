import 'package:capstone/SharedResources/app_local_storage.dart';

class GlobalStorageService {
  static late AppLocalStorage storageService;
  static Future<void> init() async {
    storageService = await AppLocalStorage().init();
  }
}
