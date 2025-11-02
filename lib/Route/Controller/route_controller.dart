import 'package:capstone/Constants/enum.dart';
import 'package:capstone/Pages/FileUpload/View/file_upload.dart';
import 'package:capstone/Pages/Home/View/home.dart';
import 'package:capstone/Pages/LogIn/View/login_page.dart';
import 'package:capstone/Pages/OnBoarding/View/onboarding_view.dart';
import 'package:capstone/Pages/Register/View/signup_page.dart';
import 'package:capstone/Reusables/Widgets/reusable_widgets.dart';
import 'package:capstone/Route/Model/route_entity.dart';
import 'package:capstone/Route/Model/routes_name.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:flutter/material.dart';

class RouteController {
  static List<RouteEntity> routes() {
    return [
      RouteEntity(path: RoutesName.onboarding, page: OnboardingPages()),
      RouteEntity(path: RoutesName.home, page: Home()),
      RouteEntity(path: RoutesName.signIn, page: LoginPage()),
      RouteEntity(path: RoutesName.signUp, page: SignUpPage()),
      RouteEntity(path: RoutesName.fileUpload, page: FilesUpload()),
    ];
  }

  static MaterialPageRoute generateRouteSettings(RouteSettings settings) {
    if (settings.name != null) {
      var result = routes().where((e) => e.path == settings.name);
      if (result.isNotEmpty) {
        bool isFirstDeviceOpen = GlobalStorageService.storageService.getBool(
          EnumValues.DEVICE_FIRST_OPEN,
        );
        if (result.first.path == RoutesName.onboarding && isFirstDeviceOpen) {
          return MaterialPageRoute(builder: (_) => Home());
        } else {
          return MaterialPageRoute(builder: (_) => OnBoardingPage());
        }
      }
    }
    return MaterialPageRoute(
      builder: (_) => OnBoardingPage(),
      settings: settings,
    );
  }
}
