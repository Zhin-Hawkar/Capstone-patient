import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:capstone/Reusables/Buttons/buttons.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  late TabController _tab_controller;
  @override
  void initState() {
    super.initState();
    _tab_controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: CustomAppBar(title: "Notifications"),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabBarNotificationsViewButtonOne(
                  tabController: _tab_controller,
                  buttonText: "new",
                  function: () {
                    setState(() {
                      _tab_controller.animateTo(0);
                    });
                  },
                ),
                TabBarNotificationsViewButtonTwo(
                  tabController: _tab_controller,
                  buttonText: "this week",
                  function: () {
                    setState(() {
                      _tab_controller.animateTo(1);
                    });
                  },
                ),
                TabBarNotificationsViewButtonThree(
                  tabController: _tab_controller,
                  buttonText: "earlier",
                  function: () {
                    setState(() {
                      _tab_controller.animateTo(2);
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tab_controller,
              children: [
                Center(child: Text("new")),
                Center(child: Text("this week")),
                Center(child: Text("earlier")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
