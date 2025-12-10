import 'package:capstone/Patient/Pages/Hospital/Model/hospital.dart';

class SearchUserController {
  static List<Hospital> searchHospitals(
    String input,
    String? selectedLocation,
    String? selectedDepartment,
    List<Hospital> hospitals,
  ) {
    final query = input.toLowerCase().trim();

    return hospitals.where((hospital) {
      final nameMatch = hospital.hospitalName!.toLowerCase().contains(query);
      final locationMatch = hospital.location!.toLowerCase().contains(query);
      final departmentMatch = hospital.departments.any(
        (dept) => dept.toLowerCase().contains(query),
      );

      final matchesQuery =
          query.isEmpty || nameMatch || locationMatch || departmentMatch;

      final matchesLocationFilter =
          selectedLocation == null ||
          hospital.location!.toLowerCase().startsWith(
            selectedLocation.toLowerCase(),
          );

      final matchesDepartmentFilter =
          selectedDepartment == null ||
          hospital.departments.any(
            (dept) => dept.toLowerCase() == selectedDepartment.toLowerCase(),
          );

      return matchesQuery && matchesLocationFilter && matchesDepartmentFilter;
    }).toList();
  }
}
