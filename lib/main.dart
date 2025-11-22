import 'package:capstone/Doctor/pages/AssignedPatientsPage/view/assigned_patients.dart';
import 'package:capstone/Doctor/pages/DoctorEditProfile/View/doctor_edit_profile_page.dart';
import 'package:capstone/Doctor/pages/DoctorHome/View/home.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/View/notification_request_detail_page.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/View/notifications.dart';
import 'package:capstone/Doctor/pages/DoctorProfile/View/doctor_profile_view_page.dart';
import 'package:capstone/Doctor/pages/Statistics/View/statistics.dart';
import 'package:capstone/InternetChecker/Controller/internet_checker_controller.dart';
import 'package:capstone/Patient/Pages/Appointments/View/doctor_profile_view_page.dart';
import 'package:capstone/Route/Controller/route_controller.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalStorageService.init();
  //InternetCheckerController.establishChecking();
  runApp(ProviderScope(child: const Capstone()));
}

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class Capstone extends StatelessWidget {
  const Capstone({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (p0, p1, p2) {
        return MaterialApp(
          navigatorKey: navKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.white)),
          initialRoute: "/",
          onGenerateRoute: (settings) =>
              RouteController.generateRouteSettings(settings),
          // home: DoctorProfileView(),
        );
      },
    );
  }
}
