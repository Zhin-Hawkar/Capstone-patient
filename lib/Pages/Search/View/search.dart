import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Pages/Search/Controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // ignore: non_constant_identifier_names
  TextEditingController text_controller = TextEditingController();
  String query = "";
  String? selectedLocation;
  String? selectedIllness;
  @override
  Widget build(BuildContext context) {
    final filteredDoctors = SearchUserController.searchDoctors(
      query,
      selectedLocation,
      selectedIllness,
    );

    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 5.w),
                  child: TextField(
                    cursorColor: AppColors.DARK_GREEN,
                    cursorHeight: 2.h,
                    cursorOpacityAnimates: true,

                    autofocus: true,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    controller: text_controller,
                    style: TextStyle(color: Colors.black),
                    strutStyle: StrutStyle(fontSize: 14),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      enabled: true,
                      hintText: "Search for illness type...",
                      hintStyle: TextStyle(fontSize: 14),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: AppColors.DARK_GREEN,
                          style: BorderStyle.solid,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: AppColors.DARK_GREEN,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 5.w),
                child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      showDragHandle: true,
                      backgroundColor: AppColors.WHITE_BACKGROUND,
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setModalState) {
                            return SizedBox(
                              height: 20.h,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10.h,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            DropdownButton<String>(
                                              value: selectedLocation,
                                              hint: Text(
                                                "Location",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              items: [
                                                DropdownMenuItem(
                                                  value: "Germany",
                                                  child: Text("Germany"),
                                                ),
                                                DropdownMenuItem(
                                                  value: "Italy",
                                                  child: Text("Italy"),
                                                ),
                                                DropdownMenuItem(
                                                  value: "Iran",
                                                  child: Text("Iran"),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                setModalState(() {
                                                  selectedLocation = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 10.h,
                                        margin: EdgeInsets.only(left: 50),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            DropdownButton<String>(
                                              value: selectedIllness,
                                              hint: Text(
                                                "Illness",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              items: [
                                                DropdownMenuItem(
                                                  value: "Cardiologist",
                                                  child: Text("Cardiologist"),
                                                ),
                                                DropdownMenuItem(
                                                  value: "Radiologist",
                                                  child: Text("Radiologist"),
                                                ),
                                                DropdownMenuItem(
                                                  value: "Hematologist",
                                                  child: Text("Hematologist"),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                setModalState(() {
                                                  selectedIllness = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: FIcon(
                    AI.AiFillFilter,
                    size: 25,
                    color: AppColors.DARK_GREEN,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final searched = filteredDoctors[index];
                return searched.isNotEmpty
                    ? ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(25),
                          child: Image.asset(
                            "assets/img/doctor/${searched['image']}",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          searched['name'],
                          style: TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          searched['hospital'],
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: Text(
                          searched['specialty'],
                          style: TextStyle(fontSize: 11),
                        ),
                      )
                    : Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
