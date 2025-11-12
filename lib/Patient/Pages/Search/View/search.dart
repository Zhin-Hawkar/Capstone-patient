import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Patient/Pages/Search/Controller/search_controller.dart';
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
  String? selectedHospital;
  String? selectedIllnessType;

  // Get unique illness types from all hospitals
  List<String> getIllnessTypes() {
    Set<String> illnessSet = {};
    for (var hospital in UserModel.hospitals) {
      final illnessTypes = hospital['illnessTypes'] as List;
      for (var illness in illnessTypes) {
        illnessSet.add(illness.toString());
      }
    }
    return illnessSet.toList()..sort();
  }

  // Get unique hospital names
  List<String> getHospitalNames() {
    return UserModel.hospitals
        .map((h) => h['name'].toString())
        .toList()
      ..sort();
  }

  // Get unique locations
  List<String> getLocations() {
    Set<String> locationSet = {};
    for (var hospital in UserModel.hospitals) {
      final location = hospital['location'].toString();
      // Extract country from location (e.g., "Germany - Berlin" -> "Germany")
      final parts = location.split(' - ');
      if (parts.isNotEmpty) {
        locationSet.add(parts[0]);
      }
    }
    return locationSet.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final filteredHospitals = query.isEmpty && selectedLocation == null && selectedHospital == null && selectedIllnessType == null
        ? <dynamic>[]
        : SearchUserController.searchHospitals(
      query,
      selectedLocation,
            selectedHospital,
            selectedIllnessType,
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
                      hintText: "Search by illnesses, location, or hospitals...",
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
                        query = value.trim();
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
                            return Container(
                              padding: EdgeInsets.all(20),
                              height: 40.h,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Filters",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.DARK_GREEN,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  // Type of Illness Filter
                                  Text(
                                    "A. Type of Illness",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  DropdownButton<String>(
                                    value: selectedIllnessType,
                                    isExpanded: true,
                                    hint: Text("Select illness type"),
                                    items: getIllnessTypes()
                                        .map((illness) => DropdownMenuItem(
                                              value: illness,
                                              child: Text(illness),
                                            ))
                                        .toList(),
                                              onChanged: (value) {
                                                setModalState(() {
                                        selectedIllnessType = value;
                                      });
                                      setState(() {
                                        selectedIllnessType = value;
                                                });
                                              },
                                            ),
                                  SizedBox(height: 2.h),
                                  // Hospitals Filter
                                  Text(
                                    "B. Hospitals",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                            DropdownButton<String>(
                                    value: selectedHospital,
                                    isExpanded: true,
                                    hint: Text("Select hospital"),
                                    items: getHospitalNames()
                                        .map((hospital) => DropdownMenuItem(
                                              value: hospital,
                                              child: Text(hospital),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setModalState(() {
                                        selectedHospital = value;
                                      });
                                      setState(() {
                                        selectedHospital = value;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 2.h),
                                  // Location Filter
                                  Text(
                                    "C. Location",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  DropdownButton<String>(
                                    value: selectedLocation,
                                    isExpanded: true,
                                    hint: Text("Select location"),
                                    items: getLocations()
                                        .map((location) => DropdownMenuItem(
                                              value: location,
                                              child: Text(location),
                                            ))
                                        .toList(),
                                              onChanged: (value) {
                                                setModalState(() {
                                        selectedLocation = value;
                                      });
                                      setState(() {
                                        selectedLocation = value;
                                                });
                                              },
                                            ),
                                  SizedBox(height: 2.h),
                                  // Clear Filters Button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setModalState(() {
                                            selectedIllnessType = null;
                                            selectedHospital = null;
                                            selectedLocation = null;
                                          });
                                          setState(() {
                                            selectedIllnessType = null;
                                            selectedHospital = null;
                                            selectedLocation = null;
                                          });
                                        },
                                        child: Text(
                                          "Clear Filters",
                                          style: TextStyle(
                                            color: AppColors.DARK_GREEN,
                                          ),
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
          SizedBox(height: 3.h),
          Expanded(
            child: query.isEmpty && selectedLocation == null && selectedHospital == null && selectedIllnessType == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Start typing to search for hospitals",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : filteredHospitals.isEmpty
                    ? Center(
                        child: Text(
                          "No hospitals found",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        itemCount: filteredHospitals.length,
              itemBuilder: (context, index) {
                          final hospital = filteredHospitals[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 3.h),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 238, 238, 238),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                          child: Image.asset(
                                    hospital['image'],
                                    height: 20.h,
                                    width: double.infinity,
                            fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 20.h,
                                        color: AppColors.DARK_GREEN
                                            .withOpacity(0.1),
                                        child: Icon(
                                          Icons.local_hospital,
                                          size: 60,
                                          color: AppColors.DARK_GREEN,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hospital['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        hospital['type'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Row(
                                        children: [
                                          Icon(Icons.pin_drop, size: 18),
                                          SizedBox(width: 2.w),
                                          Expanded(
                                            child: Text(
                                              hospital['location'],
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 1.h),
                                      Row(
                                        children: [
                                          Icon(Icons.phone, size: 18),
                                          SizedBox(width: 2.w),
                                          Text(
                                            hospital['phone'],
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        hospital['description'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        "Services:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: (hospital['services'] as List)
                                            .map((service) => Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.DARK_GREEN
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    service,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: AppColors.DARK_GREEN,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
              },
            ),
          ),
        ],
      ),
    );
  }
}
