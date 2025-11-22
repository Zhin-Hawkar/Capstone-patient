import 'package:capstone/Backend/Model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: false)
class EditDoctorNotifier extends StateNotifier<Doctor> {
  EditDoctorNotifier() : super(Doctor());

  void setFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void setLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void setLocation(String location) {
    state = state.copyWith(location: location);
  }

  void setAge(int age) {
    state = state.copyWith(age: age);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void setImage(String image) {
    state = state.copyWith(image: image);
  }

  void setSpecialization(String specialization) {
    state = state.copyWith(specialization: specialization);
  }

  // void setQualification(List<String> qualification) {
  //   state = state.copyWith(qualification: qualification);
  // }

  // void setYearsOfExperience(int yearsofexperience) {
  //   state = state.copyWith(yearsOfExperience: yearsofexperience);
  // }
  void setLicenseId(int licenseId) {
    state = state.copyWith(licenseId: licenseId);
  }

  void setDepartment(String department) {
    state = state.copyWith(department: department);
  }
}

var editDoctorProvider = StateNotifierProvider<EditDoctorNotifier, Doctor>(
  (ref) => EditDoctorNotifier(),
);
