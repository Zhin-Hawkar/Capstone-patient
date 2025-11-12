import 'package:capstone/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BookingStepTwoPage extends StatefulWidget {
  const BookingStepTwoPage({super.key, required this.initialData});

  final Map<String, dynamic> initialData;

  @override
  State<BookingStepTwoPage> createState() => _BookingStepTwoPageState();
}

class _BookingStepTwoPageState extends State<BookingStepTwoPage> {
  final TextEditingController _illnessTypeController = TextEditingController();
  final TextEditingController _assistanceController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _uploadedRecord;

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

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.DARK_GREEN,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              hourMinuteTextColor: AppColors.DARK_GREEN,
              hourMinuteColor: AppColors.DARK_GREEN.withOpacity(0.1),
              dialHandColor: AppColors.DARK_GREEN,
              dialBackgroundColor: Colors.white,
              entryModeIconColor: AppColors.DARK_GREEN,
              helpTextStyle: TextStyle(color: AppColors.DARK_GREEN),
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
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _mockUploadMedicalRecord() {
    setState(() {
      _uploadedRecord = 'medical_record.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medical record selected (mock upload).'),
      ),
    );
  }

  void _submitBooking({required bool asGuest}) {
    if (_illnessTypeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide an illness type.')),
      );
      return;
    }
    if (_assistanceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe how the doctor can help you.')),
      );
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a preferred date and time.')),
      );
      return;
    }

    final bookingSummary = {
      ...widget.initialData,
      'illnessType': _illnessTypeController.text.trim(),
      'assistance': _assistanceController.text.trim(),
      'medicalRecord': _uploadedRecord,
      'preferredDate': _selectedDate?.toIso8601String(),
      'preferredTime': _selectedTime?.format(context),
      'asGuest': asGuest,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Booking submitted ${asGuest ? 'as guest' : 'with sign in'}!\nWe will contact you soon.',
        ),
      ),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  String _formatSelectedDate() {
    if (_selectedDate == null) return 'Select date';
    return '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
  }

  String _formatSelectedTime() {
    if (_selectedTime == null) return 'Select time';
    return _selectedTime!.format(context);
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
                      Text(
                        "Medical details",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.DARK_GREEN,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: _illnessTypeController,
                        cursorColor: AppColors.DARK_GREEN,
                        style: const TextStyle(color: Colors.black),
                        decoration: _inputDecoration('Illness type'),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: _assistanceController,
                        cursorColor: AppColors.DARK_GREEN,
                        style: const TextStyle(color: Colors.black),
                        decoration: _inputDecoration('How can the doctor help you?'),
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      SizedBox(height: 2.5.h),
                      Text(
                        'Medical records (optional)',
                        style: TextStyle(
                          fontSize: 11.sp,
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
                          fontSize: 11.sp,
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
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _pickTime,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.DARK_GREEN,
                                side: BorderSide(color: AppColors.DARK_GREEN),
                              ),
                              child: Text(_formatSelectedTime()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _submitBooking(asGuest: false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.DARK_GREEN,
                        backgroundColor: Colors.white,
                        side: BorderSide(color: AppColors.DARK_GREEN),
                        padding: EdgeInsets.symmetric(vertical: 1.8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Sign In to Submit'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _submitBooking(asGuest: true),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.DARK_GREEN,
                        backgroundColor: Colors.white,
                        side: BorderSide(color: AppColors.DARK_GREEN),
                        padding: EdgeInsets.symmetric(vertical: 1.8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Submit as Guest'),
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
