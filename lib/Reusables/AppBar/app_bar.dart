import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/Pages/Appointments/View/appointments.dart';
import 'package:capstone/Pages/Home/View/home.dart';
import 'package:capstone/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/Pages/LogIn/View/login_page.dart';
import 'package:capstone/Pages/LogOut/Controller/logout_controller.dart';
import 'package:capstone/Pages/Notifications/View/notifications.dart';
import 'package:capstone/Pages/Search/View/search.dart';
import 'package:capstone/Pages/UserProfile/View/user_profile.dart';
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
                child: UserProfile(),
              ),
            );
          },
          icon: profileState.profile!.image == "null"
              ? Icon(Icons.person)
              : ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(25),
                  child: Image.asset(
                    UserModel.user['image'],
                    width: 40,
                    height: 50,
                    fit: BoxFit.cover,
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
      backgroundColor: AppColors.DARK_GREEN,
      width: 200,
      child: Container(
        margin: EdgeInsets.only(top: 20.h, bottom: 3.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: AppColors.WHITE_BACKGROUND),
                  title: Text(
                    "Home",
                    style: TextStyle(color: AppColors.WHITE_BACKGROUND),
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
                    color: AppColors.WHITE_BACKGROUND,
                  ),
                  title: Text(
                    "Notifications",
                    style: TextStyle(color: AppColors.WHITE_BACKGROUND),
                  ),
                ),
                ListTile(
                  onTap: () {
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
                    color: AppColors.WHITE_BACKGROUND,
                  ),
                  title: Text(
                    "Appointments",
                    style: TextStyle(color: AppColors.WHITE_BACKGROUND),
                  ),
                ),
              ],
            ),

            ListTile(
              leading: Icon(Icons.logout, color: AppColors.WHITE_BACKGROUND),
              title: Text(
                "LogOut",
                style: TextStyle(color: AppColors.WHITE_BACKGROUND),
              ),
              onTap: () async {
                await LogoutController.handleLogOut(ref);
                if (GlobalStorageService.storageService.getString(
                      EnumValues.ACCESS_TOKEN,
                    ) ==
                    "") {
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
