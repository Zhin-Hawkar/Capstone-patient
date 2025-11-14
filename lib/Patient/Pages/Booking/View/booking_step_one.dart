import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Patient/Pages/Booking/Notifier/send_appointment_notifier.dart';
import 'package:capstone/Patient/Pages/Booking/View/booking_step_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class BookingStepOnePage extends ConsumerStatefulWidget {
  const BookingStepOnePage({super.key});

  @override
  ConsumerState<BookingStepOnePage> createState() => _BookingStepOnePageState();
}

class _BookingStepOnePageState extends ConsumerState<BookingStepOnePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedSex;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .watch(sendAppointmentNotifierProvider.notifier)
          .setFirstName(_firstNameController.text);
      ref
          .watch(sendAppointmentNotifierProvider.notifier)
          .setLastName(_lastNameController.text);
      ref
          .watch(sendAppointmentNotifierProvider.notifier)
          .setAge(int.parse(_ageController.text));
      ref
          .watch(sendAppointmentNotifierProvider.notifier)
          .setGender(_selectedSex);
      ref
          .watch(sendAppointmentNotifierProvider.notifier)
          .setEmail(_emailController.text);
      ref
          .watch(sendAppointmentNotifierProvider.notifier)
          .setPhoneNumber(_phoneController.text);

      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: BookingStepTwoPage(),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      labelStyle: TextStyle(color: Colors.grey[600]),
      floatingLabelStyle: TextStyle(color: AppColors.DARK_GREEN),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(width: 2, color: AppColors.DARK_GREEN),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Information'),
        backgroundColor: AppColors.DARK_GREEN,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tell us about yourself",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.DARK_GREEN,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        TextFormField(
                          controller: _firstNameController,
                          cursorColor: AppColors.DARK_GREEN,
                          style: const TextStyle(color: Colors.black),
                          decoration: _inputDecoration('First name'),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your first name';
                            }
                            if (value.trim().length < 3) {
                              return 'First name must be at least 3 letters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),
                        TextFormField(
                          controller: _lastNameController,
                          cursorColor: AppColors.DARK_GREEN,
                          style: const TextStyle(color: Colors.black),
                          decoration: _inputDecoration('Last name'),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your last name';
                            }
                            if (value.trim().length < 3) {
                              return 'Last name must be at least 3 letters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),
                        TextFormField(
                          controller: _ageController,
                          cursorColor: AppColors.DARK_GREEN,
                          style: const TextStyle(color: Colors.black),
                          decoration: _inputDecoration('Age'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your age';
                            }
                            final age = int.tryParse(value);
                            if (age == null || age <= 0) {
                              return 'Please enter a valid age';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),
                        DropdownButtonFormField<String>(
                          value: _selectedSex,
                          decoration: _inputDecoration('Sex'),
                          iconEnabledColor: AppColors.DARK_GREEN,
                          dropdownColor: Colors.white,
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'Other',
                              child: Text('Other'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedSex = value;
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
                        TextFormField(
                          controller: _phoneController,
                          cursorColor: AppColors.DARK_GREEN,
                          style: const TextStyle(color: Colors.black),
                          decoration:
                              _inputDecoration(
                                'Phone number',
                                hint: '770 123 4567',
                              ).copyWith(
                                prefixText: '+964 ',
                                prefixStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            final trimmed = value?.trim() ?? '';
                            if (trimmed.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (trimmed.length != 10) {
                              return 'Phone number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),
                        TextFormField(
                          controller: _emailController,
                          cursorColor: AppColors.DARK_GREEN,
                          style: const TextStyle(color: Colors.black),
                          decoration: _inputDecoration(
                            'Email',
                            hint: 'avanahmed@gmail.com',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegex = RegExp(
                              r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                            );
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _goToNextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.DARK_GREEN,
                      padding: EdgeInsets.symmetric(vertical: 1.8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
