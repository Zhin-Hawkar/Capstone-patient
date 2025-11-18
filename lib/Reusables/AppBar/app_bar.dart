import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/view/assigned_patients.dart';
import 'package:capstone/Doctor/pages/DoctorAppointments/View/appointments.dart';
import 'package:capstone/Doctor/pages/DoctorHome/View/home.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/View/notifications.dart';
import 'package:capstone/Doctor/pages/Statistics/View/statistics.dart';
import 'package:capstone/Patient/Pages/Appointments/View/appointments.dart';
import 'package:capstone/Patient/Pages/Home/View/home.dart';
import 'package:capstone/Patient/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/Patient/Pages/LogIn/View/login_page.dart';
import 'package:capstone/Patient/Pages/LogOut/Controller/logout_controller.dart';
import 'package:capstone/Patient/Pages/Notifications/View/notifications.dart';
import 'package:capstone/Patient/Pages/Search/View/search.dart';
import 'package:capstone/Patient/Pages/UserProfile/View/user_profile.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  String? title;

  CustomAppBar({super.key, this.title});

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size(100.w, 7.h);
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(signInNotifierProvider);
    return AppBar(
      title: Text(widget.title.toString()),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: SearchPage(),
              ),
            );
          },
          icon: Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child:
                    GlobalStorageService.storageService
                        .getString(EnumValues.ACCESS_TOKEN)
                        .isEmpty
                    ? LoginPage()
                    : UserProfile(),
              ),
            );
          },
          icon:
              profileState.profile?.image == null ||
                  profileState.profile!.image == "null"
              ? Icon(Icons.person)
              : ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(25),
                  child: SizedBox(
                    width: 40,
                    height: 50,
                    child: Image.network(
                      "${profileState.profile!.image}",
                      width: 40,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class CustomAppBarNoButton extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  String? title;

  CustomAppBarNoButton({super.key, this.title});

  @override
  ConsumerState<CustomAppBarNoButton> createState() =>
      _CustomAppBarNoButtonState();

  @override
  Size get preferredSize => Size(100.w, 7.h);
}

class _CustomAppBarNoButtonState extends ConsumerState<CustomAppBarNoButton> {
  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(widget.title.toString()), centerTitle: true);
  }
}

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({super.key});

  @override
  ConsumerState<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      width: 200,
      child: Container(
        margin: EdgeInsets.only(top: 20.h, bottom: 3.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: AppColors.DARK_GREEN),
                  title: Text(
                    "Home",
                    style: TextStyle(
                      color: AppColors.DARK_GREEN,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: Home(),
                      ),
                    ),
                  },
                ),
                ListTile(
                  onTap: () {
                    if (GlobalStorageService.storageService
                        .getString(EnumValues.ACCESS_TOKEN)
                        .isEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "please login first to see notifications",
                          ),
                        ),
                      );
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: Notifications(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.notifications,
                    color: AppColors.DARK_GREEN,
                  ),
                  title: Text(
                    "Notifications",
                    style: TextStyle(
                      color: AppColors.DARK_GREEN,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    if (GlobalStorageService.storageService
                        .getString(EnumValues.ACCESS_TOKEN)
                        .isEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "please login first to see appointments",
                          ),
                        ),
                      );
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: Appointments(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.calendar_month,
                    color: AppColors.DARK_GREEN,
                  ),
                  title: Text(
                    "Appointments",
                    style: TextStyle(
                      color: AppColors.DARK_GREEN,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            GlobalStorageService.storageService
                    .getString(EnumValues.ACCESS_TOKEN)
                    .isEmpty
                ? ListTile(
                    leading: Icon(Icons.login, color: AppColors.DARK_GREEN),
                    title: Text(
                      "Login",
                      style: TextStyle(
                        color: AppColors.DARK_GREEN,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: LoginPage(),
                        ),
                      );
                    },
                  )
                : ListTile(
                    leading: Icon(Icons.logout, color: AppColors.DARK_GREEN),
                    title: Text(
                      "LogOut",
                      style: TextStyle(
                        color: AppColors.DARK_GREEN,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      await LogoutController.handleLogOut(ref);
                      if (GlobalStorageService.storageService
                          .getString(EnumValues.ACCESS_TOKEN)
                          .isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color.fromARGB(120, 0, 0, 0),
                            content: Text(
                              "User Logged out Successfully!",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: LoginPage(),
                          ),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class CustomDoctorDrawer extends ConsumerStatefulWidget {
  const CustomDoctorDrawer({super.key});

  @override
  ConsumerState<CustomDoctorDrawer> createState() => _CustomDoctorDrawer();
}

class _CustomDoctorDrawer extends ConsumerState<CustomDoctorDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      width: 200,
      child: Container(
        margin: EdgeInsets.only(top: 20.h, bottom: 3.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: AppColors.DARK_GREEN),
                  title: Text(
                    "Home",
                    style: TextStyle(
                      color: AppColors.DARK_GREEN,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: DoctorHome(),
                      ),
                    ),
                  },
                ),
                ListTile(
                  onTap: () {
                    if (GlobalStorageService.storageService
                        .getString(EnumValues.ACCESS_TOKEN)
                        .isEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "please login first to see notifications",
                          ),
                        ),
                      );
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: DoctorNotifications(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.notifications,
                    color: AppColors.DARK_GREEN,
                  ),
                  title: Text(
                    "Notifications",
                    style: TextStyle(
                      color: AppColors.DARK_GREEN,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    if (GlobalStorageService.storageService
                        .getString(EnumValues.ACCESS_TOKEN)
                        .isEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("please login first to see patients"),
                        ),
                      );
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: AssignedPatients(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.calendar_month,
                    color: AppColors.DARK_GREEN,
                  ),
                  title: Text(
                    "Patients",
                    style: TextStyle(
                      color: AppColors.DARK_GREEN,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    if (GlobalStorageService.storageService
                        .getString(EnumValues.ACCESS_TOKEN)
                        .isEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "please login first to see appointments",
                          ),
                        ),
                      );
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: DoctorsAppointments(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.calendar_month,
                    color: AppColors.DARK_GREEN,
                  ),
                  title: Text(
                    "Appointments",
                    style: TextStyle(
                      color: AppColors.DARK_GREEN,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    if (GlobalStorageService.storageService
                        .getString(EnumValues.ACCESS_TOKEN)
                        .isEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("please login first to see statistics"),
                        ),
                      );
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: Statistics(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.calendar_month,
                    color: AppColors.DARK_GREEN,
                  ),
                  title: Text(
                    "Statistics",
                    style: TextStyle(
                      color: AppColors.DARK_GREEN,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            GlobalStorageService.storageService
                    .getString(EnumValues.ACCESS_TOKEN)
                    .isEmpty
                ? ListTile(
                    leading: Icon(Icons.login, color: AppColors.DARK_GREEN),
                    title: Text(
                      "Login",
                      style: TextStyle(
                        color: AppColors.DARK_GREEN,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: LoginPage(),
                        ),
                      );
                    },
                  )
                : ListTile(
                    leading: Icon(Icons.logout, color: AppColors.DARK_GREEN),
                    title: Text(
                      "LogOut",
                      style: TextStyle(
                        color: AppColors.DARK_GREEN,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      await LogoutController.handleLogOut(ref);
                      if (GlobalStorageService.storageService
                          .getString(EnumValues.ACCESS_TOKEN)
                          .isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color.fromARGB(120, 0, 0, 0),
                            content: Text(
                              "User Logged out Successfully!",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: LoginPage(),
                          ),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
