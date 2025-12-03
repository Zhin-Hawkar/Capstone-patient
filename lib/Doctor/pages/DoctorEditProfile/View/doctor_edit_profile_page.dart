import 'dart:io';

import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/DoctorEditProfile/Controller/edit_controller.dart';
import 'package:capstone/Doctor/pages/DoctorEditProfile/Notifier/edit_notifier.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Model/doctor_notification.dart';
import 'package:capstone/FileManipulation/UploadFiles/upload_files.dart';
import 'package:capstone/Patient/Pages/EditProfile/Controller/edit_controller.dart';
import 'package:capstone/Patient/Pages/LogIn/Model/sign_in_model.dart';
import 'package:capstone/Patient/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class DoctorEditProfilePage extends ConsumerStatefulWidget {
  DoctorEditProfilePage({super.key});

  @override
  ConsumerState<DoctorEditProfilePage> createState() =>
      _DoctorEditProfilePageState();
}

class _DoctorEditProfilePageState extends ConsumerState<DoctorEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File _imageFile = File("");
  final Set<String> _selectedDays = {'Mon', 'Tue', 'Thu'};
  bool _telehealthEnabled = true;
  TextEditingController _first_name_controller = TextEditingController();
  TextEditingController _last_name_controller = TextEditingController();
  TextEditingController _specialization_controller = TextEditingController();
  TextEditingController _license_id_controller = TextEditingController();
  TextEditingController _location_controller = TextEditingController();
  TextEditingController _age_controller = TextEditingController();
  TextEditingController _years_of_experience_controller =
      TextEditingController();
  TextEditingController _description_controller = TextEditingController();
  TextEditingController _department_controller = TextEditingController();
  TextEditingController _qualification_controller = TextEditingController();

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _save() async {
    final profileState = ref.watch(signInNotifierProvider);
    ref
        .watch(editDoctorProvider.notifier)
        .setFirstName(
          _first_name_controller.text == ""
              ? profileState.doctor!.firstName.toString()
              : _first_name_controller.text,
        );
    ref
        .watch(editDoctorProvider.notifier)
        .setSpecialization(
          _specialization_controller.text == ""
              ? profileState.doctor!.specialization.toString()
              : _specialization_controller.text,
        );
    ref
        .watch(editDoctorProvider.notifier)
        .setLastName(
          _last_name_controller.text == ""
              ? profileState.doctor!.lastName.toString()
              : _last_name_controller.text,
        );
    ref
        .watch(editDoctorProvider.notifier)
        .setLocation(
          _location_controller.text == ""
              ? profileState.doctor!.location.toString()
              : _location_controller.text,
        );
    ref
        .watch(editDoctorProvider.notifier)
        .setAge(
          (_age_controller.text.isEmpty)
              ? (profileState.doctor!.age ?? 0) // fallback if null
              : int.tryParse(_age_controller.text) ?? 0,
        );
    ref
        .watch(editDoctorProvider.notifier)
        .setYearsOfExperience(
          (_years_of_experience_controller.text.isEmpty)
              ? (profileState.doctor!.yearsOfExperience ??
                    0) // fallback if null
              : int.tryParse(_years_of_experience_controller.text) ?? 0,
        );
    ref
        .watch(editDoctorProvider.notifier)
        .setLicenseId(
          _license_id_controller.text.isEmpty
              ? int.parse(profileState.doctor!.licenseId.toString())
              : int.parse(_license_id_controller.text),
        );
    ref
        .watch(editDoctorProvider.notifier)
        .setDescription(
          _description_controller.text == ""
              ? profileState.doctor!.description.toString()
              : _description_controller.text,
        );
    ref
        .watch(editDoctorProvider.notifier)
        .setDepartment(
          _department_controller.text == ""
              ? profileState.doctor!.department.toString()
              : _department_controller.text,
        );
    ref
        .watch(editDoctorProvider.notifier)
        .setQualification(
          _qualification_controller.text == ""
              ? profileState.doctor!.qualification.toString()
              : _qualification_controller.text,
        );
    ref.watch(editDoctorProvider.notifier).setImage(_imageFile.path);

    ref
        .watch(editDoctorProvider.notifier)
        .setEmail(profileState.doctor!.email.toString());

    final result = await EditDoctorController.handleDoctorEdit(context, ref);
    if (result['code'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  void dispose() {
    _first_name_controller.dispose();
    _last_name_controller.dispose();
    _specialization_controller.dispose();
    _license_id_controller.dispose();
    _location_controller.dispose();
    _age_controller.dispose();
    _years_of_experience_controller.dispose();
    _description_controller.dispose();
    _department_controller.dispose();
    _qualification_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctorProfile = ref.watch(signInNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: AppBar(
        title: const Text('Edit Doctor Profile'),
        actions: [
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 5.w),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 213, 213, 213),
                borderRadius: BorderRadius.circular(70),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(70),
                    child: _imageFile.path.isEmpty
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                size: 100,
                                color: const Color.fromARGB(255, 125, 125, 125),
                              ),
                            ],
                          )
                        : SizedBox(
                            width: 120,
                            height: 120,
                            child: Image.file(_imageFile!, fit: BoxFit.cover),
                          ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                showDragHandle: true,
                                backgroundColor: AppColors.WHITE_BACKGROUND,
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: 10.h,
                                    child: ListTile(
                                      title: Text("Upload image"),
                                      onTap: () async {
                                        List<PlatformFile>? files =
                                            await UploadFiles.pickAndUploadFiles();
                                        if (files != null) {
                                          for (
                                            int i = 0;
                                            i < files.length;
                                            i++
                                          ) {
                                            setState(() {
                                              _imageFile = File(
                                                files.single.path!,
                                              );
                                            });
                                          }
                                        }
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(108, 213, 213, 213),
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: doctorProfile.doctor?.image != null
                                  ? Image.network(
                                      "${doctorProfile.doctor?.image}",
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: const Color.fromARGB(111, 0, 0, 0),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _SectionCard(
                      title: 'Professional information',
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _first_name_controller,
                            decoration: InputDecoration(
                              labelText:
                                  doctorProfile.doctor?.firstName ??
                                  'First Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _last_name_controller,
                            decoration: InputDecoration(
                              labelText:
                                  doctorProfile.doctor?.lastName ?? 'Last Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _specialization_controller,
                            decoration: InputDecoration(
                              labelText:
                                  doctorProfile.doctor?.specialization ??
                                  'Specialization',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _qualification_controller,
                            decoration: InputDecoration(
                              labelText:
                                  doctorProfile.doctor?.qualification ??
                                  'Qualification',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _location_controller,
                            decoration: InputDecoration(
                              labelText:
                                  doctorProfile.doctor?.location ?? 'Location',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _age_controller,
                            decoration: InputDecoration(
                              labelText:
                                  '${doctorProfile.doctor?.age ?? 'Age'}',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _description_controller,
                            decoration: InputDecoration(
                              labelText:
                                  doctorProfile.doctor?.description ??
                                  'Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _years_of_experience_controller,
                            decoration: InputDecoration(
                              labelText:
                                  '${doctorProfile.doctor?.yearsOfExperience ?? 'Years of experience'}',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _department_controller,
                            decoration: InputDecoration(
                              labelText:
                                  doctorProfile.doctor?.department ??
                                  'Department',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _license_id_controller,
                            decoration: InputDecoration(
                              labelText:
                                  '${doctorProfile.doctor?.licenseId ?? 'License Id'}',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _SectionCard(
                      title: 'Availability',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            children: _weekDays
                                .map(
                                  (day) => ChoiceChip(
                                    label: Text(day),
                                    selected: _selectedDays.contains(day),
                                    onSelected: (_) => _toggleDay(day),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: '8:00 AM',
                                  decoration: InputDecoration(
                                    labelText: "Clinic Start",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  initialValue: '5:00 PM',
                                  decoration: InputDecoration(
                                    labelText: "Clinic End",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.initialValue});

  final String label;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }
}

const _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
