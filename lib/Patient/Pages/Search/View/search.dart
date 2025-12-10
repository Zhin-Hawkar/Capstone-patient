import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Patient/Pages/Hospital/Controller/hospital_controller.dart';
import 'package:capstone/Patient/Pages/Hospital/Model/hospital.dart';
import 'package:capstone/Patient/Pages/Hospital/View/hospital_profile_page.dart';
import 'package:capstone/Patient/Pages/Search/Controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();
  String query = "";
  String? selectedLocation;
  String? selectedDepartment;

  List<Hospital> hospitals = [];

  Future<void> fetchHospitals() async {
    List<Hospital> result = await HospitalController.getAllHospitals();
    setState(() {
      hospitals = result;
    });
  }

  List<String> getLocations() {
    return hospitals
        .map((h) => h.location ?? "")
        .where((x) => x.isNotEmpty)
        .toSet()
        .toList();
  }

  List<String> getDepartments() {
    Set<String> deptSet = {};
    for (var hospital in hospitals) {
      for (var dept in hospital.departments) {
        deptSet.add(dept);
      }
    }
    return deptSet.toList();
  }

  @override
  void initState() {
    super.initState();
    fetchHospitals();
  }

  @override
  Widget build(BuildContext context) {
    final filteredHospitals = SearchUserController.searchHospitals(
      query,
      selectedLocation,
      selectedDepartment,
      hospitals,
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
                    controller: textController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText:
                          "Search by illnesses, location, or hospitals...",
                      hintStyle: const TextStyle(fontSize: 14),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: AppColors.DARK_GREEN),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: AppColors.DARK_GREEN),
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
                              padding: const EdgeInsets.all(20),
                              height: 50.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.DARK_GREEN,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),

                                  DropdownButton<String>(
                                    value: selectedLocation,
                                    isExpanded: true,
                                    hint: const Text("Select location"),
                                    items: getLocations().map((loc) {
                                      return DropdownMenuItem(
                                        value: loc,
                                        child: Text(loc),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setModalState(
                                        () => selectedLocation = value,
                                      );
                                      setState(() => selectedLocation = value);
                                    },
                                  ),
                                  SizedBox(height: 2.h),

                                  DropdownButton<String>(
                                    value: selectedDepartment,
                                    isExpanded: true,
                                    hint: const Text("Select department"),
                                    items: getDepartments().map((dept) {
                                      return DropdownMenuItem(
                                        value: dept,
                                        child: Text(dept),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setModalState(
                                        () => selectedDepartment = value,
                                      );
                                      setState(
                                        () => selectedDepartment = value,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 2.h),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        setModalState(() {
                                          selectedLocation = null;
                                          selectedDepartment = null;
                                        });
                                        setState(() {
                                          selectedLocation = null;
                                          selectedDepartment = null;
                                        });
                                      },
                                      child: Text(
                                        "Clear Filter",
                                        style: TextStyle(
                                          color: AppColors.DARK_GREEN,
                                        ),
                                      ),
                                    ),
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
            child: filteredHospitals.isEmpty
                ? Center(
                    child: Text(
                      query.isEmpty &&
                              selectedLocation == null &&
                              selectedDepartment == null
                          ? "Start typing to search for hospitals"
                          : "No hospitals found",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    itemCount: filteredHospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = filteredHospitals[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: HospitalProfilePage(hospital: hospital),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 3.h),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 238, 238, 238),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Image.network(
                                  hospital.image ?? "",
                                  height: 20.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 20.h,
                                      color: AppColors.DARK_GREEN.withOpacity(
                                        0.1,
                                      ),
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
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hospital.hospitalName ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      hospital.departments.join(", "),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Row(
                                      children: [
                                        const Icon(Icons.pin_drop, size: 18),
                                        SizedBox(width: 2.w),
                                        Expanded(
                                          child: Text(
                                            hospital.location ?? "",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.h),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone, size: 18),
                                        SizedBox(width: 2.w),
                                        Text(
                                          hospital.phoneNumber ?? "",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      hospital.description ?? "",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2.h),
                                    const Text(
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
                                      children: hospital.services.map((
                                        service,
                                      ) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.DARK_GREEN
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            service,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: AppColors.DARK_GREEN,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
