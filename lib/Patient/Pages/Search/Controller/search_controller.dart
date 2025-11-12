import 'package:capstone/Backend/Model/user_model.dart';

class SearchUserController {
  static List<dynamic> doctors = [
    {
      'name': "Xwncha Rahman",
      'specialty': "Cardiologist",
      'degree': "MBBS/MD",
      'hospital': "Charité – Universitätsmedizin Berlin",
      'location': "Germany - Berlin",
      'image': "female-doctor-hospital-with-stethoscope.jpg",
    },
    {
      'name': "Sabah Kalary",
      'specialty': "Radiologist",
      'degree': "MBBS/MD",
      'hospital': "Charité – Universitätsmedizin Berlin",
      'location': "Germany - Berlin",
      'image':
          "attractive-young-male-nutriologist-lab-coat-smiling-against-white-background.jpg",
    },
    {
      'name': "Sardar Kareem",
      'specialty': "Hematologist",
      'degree': "MBBS/MD",
      'hospital': "Charité – Universitätsmedizin Berlin",
      'location': "Germany - Berlin",
      'image': "bearded-doctor-glasses.jpg",
    },
    {
      'name': "Karwan Fatah",
      'specialty': "Cardiologist",
      'degree': "MBBS/MD",
      'hospital': "Charité – Universitätsmedizin Berlin",
      'location': "Germany - Berlin",
      'image':
          "portrait-experienced-professional-therapist-with-stethoscope-looking-camera.jpg",
    },
    {
      'name': "Kamaran Salar",
      'specialty': "Cardiologist",
      'degree': "MBBS/MD",
      'hospital': "Charité – Universitätsmedizin Berlin",
      'location': "Germany - Berlin",
      'image': "smiling-doctor-sitting-isolated-grey.jpg",
    },
  ];

  static List<dynamic> searchDoctors(
    String input,
    String? selectedLocation,
    String? selectedIllness,
  ) {
    final result = doctors.where((doctor) {
      final matchesQuery =
          input.isEmpty ||
          doctor["specialty"].toString().toLowerCase().contains(
            input.toLowerCase(),
          );
      final matchesLocation =
          selectedLocation == null ||
          doctor["location"].toString().toLowerCase().contains(
            selectedLocation.toLowerCase(),
          );
      final matchesIllness =
          selectedIllness == null ||
          doctor["specialty"].toString().toLowerCase().contains(
            selectedIllness.toLowerCase(),
          );

      return matchesQuery && matchesLocation && matchesIllness;
    }).toList();
    return result;
  }

  static List<dynamic> searchHospitals(
    String input,
    String? selectedLocation,
    String? selectedHospital,
    String? selectedIllnessType,
  ) {
    final query = input.toLowerCase().trim();
    final result = UserModel.hospitals.where((hospital) {
      // Search by hospital name (when typing)
      final matchesHospitalName = query.isEmpty ||
          hospital['name']
              .toString()
              .toLowerCase()
              .contains(query);

      // Search by location (when typing)
      final matchesLocation = query.isEmpty ||
          hospital['location']
              .toString()
              .toLowerCase()
              .contains(query);

      // Search by illness types (when typing)
      final illnessTypes = hospital['illnessTypes'] as List;
      final matchesIllnessTypes = query.isEmpty ||
          illnessTypes.any((illness) =>
              illness.toString().toLowerCase().contains(query));

      // Filter by selected location (matches country from location string)
      final matchesSelectedLocation = selectedLocation == null ||
          hospital['location']
              .toString()
              .toLowerCase()
              .startsWith(selectedLocation.toLowerCase());

      // Filter by selected hospital name
      final matchesSelectedHospital = selectedHospital == null ||
          hospital['name']
              .toString()
              .toLowerCase()
              .contains(selectedHospital.toLowerCase());

      // Filter by selected illness type
      final matchesSelectedIllnessType = selectedIllnessType == null ||
          illnessTypes.any((illness) =>
              illness.toString().toLowerCase() ==
              selectedIllnessType.toLowerCase());

      // Match if query matches hospital name, location, or illness types
      // AND all selected filters match
      final matchesQuery = query.isEmpty ||
          matchesHospitalName ||
          matchesLocation ||
          matchesIllnessTypes;

      return matchesQuery &&
          matchesSelectedLocation &&
          matchesSelectedHospital &&
          matchesSelectedIllnessType;
    }).toList();

    return result;
  }
}
