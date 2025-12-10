import 'dart:io';

import 'package:capstone/Constants/colors.dart';
import 'package:capstone/FileManipulation/UploadFiles/upload_files.dart';
import 'package:capstone/Patient/Pages/Booking/Controller/send_appointment_controller.dart';
import 'package:capstone/Patient/Pages/Booking/Notifier/send_appointment_notifier.dart';
import 'package:capstone/Patient/Pages/Home/View/home.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class BookingStepTwoPage extends ConsumerStatefulWidget {
  const BookingStepTwoPage({super.key});

  @override
  ConsumerState<BookingStepTwoPage> createState() => _BookingStepTwoPageState();
}

class _BookingStepTwoPageState extends ConsumerState<BookingStepTwoPage> {
  final TextEditingController _illnessTypeController = TextEditingController();
  final TextEditingController _assistanceController = TextEditingController();
  DateTime? _selectedDate;
  bool isSubmited = false;
  String? _uploadedRecord;
  String? _selectedDepartment;
  File _imageFile = File("");
  List<dynamic> departments = [];
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
      floatingLabelStyle: TextStyle(color: AppColors.DARK_GREEN),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.DARK_GREEN, width: 2),
      ),
    );
  }

  @override
  void dispose() {
    _illnessTypeController.dispose();
    _assistanceController.dispose();
    super.dispose();
  }

  Future<void> getDepartment() async {
    final result = await SendAppointmentController.getDepartments();
    setState(() {
      departments = result;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.DARK_GREEN,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.DARK_GREEN,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _mockUploadMedicalRecord() async {
    List<PlatformFile>? files = await UploadFiles.pickAndUploadFiles();
    if (files != null) {
      for (int i = 0; i < files.length; i++) {
        setState(() {
          _imageFile = File(files.single.path!);
        });
      }
      setState(() {
        _uploadedRecord = _imageFile.path;
      });
    }
  }

  void _submitBooking() async {
    if (_selectedDepartment.toString().trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide an illness type.')),
      );
      return;
    }
    if (_assistanceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe how the doctor can help you.'),
        ),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a preferred date and time.'),
        ),
      );
      return;
    }
    setState(() {
      isSubmited = true;
    });
    ref
        .watch(sendAppointmentNotifierProvider.notifier)
        .setDepartment(_selectedDepartment);
    ref
        .watch(sendAppointmentNotifierProvider.notifier)
        .setHelp(_assistanceController.text);
    ref
        .watch(sendAppointmentNotifierProvider.notifier)
        .setMedicalRecord(_uploadedRecord);
    ref
        .watch(sendAppointmentNotifierProvider.notifier)
        .setDateTime(_selectedDate);

    final result = await SendAppointmentController.handleAppointment(ref);
    if (result == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking submitted, doctors will respond you soon.'),
        ),
      );
      setState(() {
        isSubmited = false;
      });
      Navigator.push(
        context,
        PageTransition(type: PageTransitionType.rightToLeft, child: Home()),
      );
    }
  }

  String _formatSelectedDate() {
    if (_selectedDate == null) return 'Select date';
    return '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDepartment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: AppColors.DARK_GREEN,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedDepartment,
                        decoration: _inputDecoration('Departmemnt'),
                        iconEnabledColor: AppColors.DARK_GREEN,
                        dropdownColor: Colors.white,
                        items: departments.map((e) {
                          return DropdownMenuItem(value: '$e', child: Text(e));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your sex';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: _assistanceController,
                        cursorColor: AppColors.DARK_GREEN,
                        style: const TextStyle(color: Colors.black),
                        decoration: _inputDecoration(
                          'How can the doctor help you?',
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      SizedBox(height: 2.5.h),
                      Text(
                        'Medical records (optional)',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.DARK_GREEN,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      OutlinedButton.icon(
                        onPressed: _mockUploadMedicalRecord,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.DARK_GREEN,
                          side: BorderSide(color: AppColors.DARK_GREEN),
                        ),
                        icon: const Icon(Icons.upload_file),
                        label: Text(
                          _uploadedRecord == null
                              ? 'Upload medical record'
                              : 'Selected: $_uploadedRecord',
                        ),
                      ),
                      SizedBox(height: 2.5.h),
                      Text(
                        'Preferred appointment time',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.DARK_GREEN,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _pickDate,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.DARK_GREEN,
                                side: BorderSide(color: AppColors.DARK_GREEN),
                              ),
                              child: Text(_formatSelectedDate()),
                            ),
                          ),
                          SizedBox(width: 3.w),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              isSubmited
                  ? Transform.scale(
                      scale: 1.6,
                      child: Lottie.asset(
                        "assets/json/Material wave loading.json",
                        width: 100,
                        height: 100,
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _submitBooking(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.DARK_GREEN,
                              backgroundColor: Colors.white,
                              side: BorderSide(color: AppColors.DARK_GREEN),
                              padding: EdgeInsets.symmetric(vertical: 1.8.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
