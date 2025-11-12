import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/Statistics/Controller/statistics_controller.dart';
import 'package:capstone/Doctor/pages/Statistics/Model/statistics_model.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  StatisticsModel? statistics = StatisticsModel();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    setState(() {
      isLoading = true;
    });
    StatisticsModel result = await getStatistics();
    setState(() {
      statistics = result;
      isLoading = false;
    });
  }

  Future<dynamic> getStatistics() async {
    StatisticsModel result = await StatisticsController.handleStatistics();
    return result;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      backgroundColor: AppColors.WHITE_BACKGROUND,
      body: SingleChildScrollView(
        child: statistics?.patients != null || statistics?.patients != null
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10.w, top: 2.h),
                        child: Text(
                          "Statistics",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.DARK_GREEN,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.h, left: 2.w, right: 2.w),
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(117, 165, 254, 221),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Patients",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${statistics?.patients}",
                                style: TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(),
                        Container(
                          margin: EdgeInsets.only(right: 5.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Requests",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${statistics?.requests}",
                                style: TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.h, right: 2.w, left: 2.w),
                    height: 400,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(117, 165, 254, 221),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 35.h,
                          width: double.infinity,
                          child: PieChart(
                            PieChartData(
                              borderData: FlBorderData(show: false),
                              centerSpaceRadius: 40,
                              sectionsSpace: 2,
                              sections: [
                                PieChartSectionData(
                                  showTitle: true,
                                  value: statistics?.patients?.toDouble() ?? 0,
                                  color: Colors.blueAccent,
                                  title: "${statistics?.patients}",
                                  radius: 70,
                                  titleStyle: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: statistics?.requests?.toDouble() ?? 0,
                                  color: Colors.orangeAccent,
                                  title: "${statistics?.requests}",
                                  radius: 70,
                                  titleStyle: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text("Number of patients and requests"),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  color: Colors.orangeAccent,
                                ),
                                SizedBox(width: 2.w),
                                Text("Patients"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(width: 2.w),
                                Text("Requests"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : isLoading
            ? Center(
                child: Transform.scale(
                  scale: 1.6,
                  child: Lottie.asset(
                    "assets/json/Material wave loading.json",
                    width: 100,
                    height: 100,
                  ),
                ),
              )
            : Container(
                margin: EdgeInsetsDirectional.only(bottom: 30.h),
                child: Transform.scale(
                  scale: 0.8,
                  child: Lottie.asset("assets/json/no data found.json"),
                ),
              ),
      ),
    );
  }
}
