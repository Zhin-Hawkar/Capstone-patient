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
}
