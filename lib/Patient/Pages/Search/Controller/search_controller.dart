import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Patient/Pages/Hospital/Model/hospital.dart';

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

  static List<dynamic> searchHospitals(String input, String? selectedLocation, List<Hospital> hospitals) {
    final query = input.toLowerCase().trim();
    final result = hospitals.where((hospital) {
      // Search by hospital name (when typing)
      final matchesHospitalName =
          query.isEmpty ||
          hospital.hospitalName.toString().toLowerCase().contains(query);

      // Search by location (when typing)
      final matchesLocation =
          query.isEmpty ||
          hospital.location.toString().toLowerCase().contains(query);

      // Search by illness types (when typing)
      final illnessTypes = hospital.departments;
      final matchesIllnessTypes =
          query.isEmpty ||
          illnessTypes.any(
            (illness) => illness.toString().toLowerCase().contains(query),
          );

      // Filter by selected location (matches country from location string)
      final matchesSelectedLocation =
          selectedLocation == null ||
          hospital.location.toString().toLowerCase().startsWith(
            selectedLocation.toLowerCase(),
          );

      // Filter by selected hospital name

      // Match if query matches hospital name, location, or illness types
      // AND all selected filters match
      final matchesQuery =
          query.isEmpty ||
          matchesHospitalName ||
          matchesLocation ||
          matchesIllnessTypes;

      return matchesQuery && matchesSelectedLocation;
    }).toList();

    return result;
  }
}
