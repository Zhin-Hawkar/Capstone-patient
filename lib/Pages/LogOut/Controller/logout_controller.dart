import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutController {
  static Future<void> handleLogOut(WidgetRef ref) async {
    await _logOut();
    GlobalStorageService.storageService.remove(EnumValues.ACCESS_TOKEN);
  }

  static _logOut() async {
    var result = await HttpUtil().post("api/logout");
    return result;
  }
}
