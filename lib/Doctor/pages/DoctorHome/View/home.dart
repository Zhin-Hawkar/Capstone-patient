import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    final patients = UserModel.doctorPatients;
    final assignedPatients = patients
        .where((patient) => patient['status'] == 'assigned')
        .toList();
    final pendingRequests = patients
        .where((patient) => patient['status'] == 'pending')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        backgroundColor: AppColors.DARK_GREEN,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.WHITE_BACKGROUND,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, Doctor',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.DARK_GREEN,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Here is a quick overview of your patients.',
              style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Assigned Patients',
                    value: assignedPatients.length.toString(),
                    icon: Icons.people_alt_rounded,
                    color: AppColors.DARK_GREEN,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _StatCard(
                    title: 'Pending Requests',
                    value: pendingRequests.length.toString(),
                    icon: Icons.pending_actions_rounded,
                    color: Colors.orange[600] ?? Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              'Assigned Patients',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.DARK_GREEN,
              ),
            ),
            SizedBox(height: 1.5.h),
            if (assignedPatients.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.inbox_outlined,
                        size: 32.sp, color: Colors.grey[600]),
                    SizedBox(height: 1.5.h),
                    Text(
                      'No patients assigned yet.',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: assignedPatients.length,
                separatorBuilder: (_, __) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  final patient = assignedPatients[index];
                  return _PatientCard(patient: patient);
                },
              ),
            SizedBox(height: 4.h),
            Text(
              'Pending Requests',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.DARK_GREEN,
              ),
            ),
            SizedBox(height: 1.5.h),
            if (pendingRequests.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.task_alt_outlined,
                        size: 28.sp, color: Colors.grey[600]),
                    SizedBox(height: 1.h),
                    Text(
                      'No pending requests at the moment.',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: pendingRequests.map((patient) {
                  return _PendingCard(patient: patient);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            height: 6.h,
            width: 6.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 3.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({required this.patient});

  final Map<String, dynamic> patient;

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFromName(patient['name'] as String);
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 5.h,
            backgroundColor: AppColors.DARK_GREEN.withOpacity(0.15),
            child: Text(
              initials,
              style: TextStyle(
                color: AppColors.DARK_GREEN,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient['name'],
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${patient['age']} years • ${patient['condition']}',
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    Icon(Icons.event_available, size: 16.sp, color: AppColors.DARK_GREEN),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Last visit: ${patient['lastVisit']}',
                        style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.8.h),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16.sp, color: AppColors.DARK_GREEN),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Next visit: ${patient['nextVisit']}',
                        style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.2.h),
                Text(
                  patient['notes'] ?? '',
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _initialsFromName(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) {
      return '';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    final firstInitial = parts.first.substring(0, 1).toUpperCase();
    final lastInitial = parts.last.substring(0, 1).toUpperCase();
    return '$firstInitial$lastInitial';
  }
}

class _PendingCard extends StatelessWidget {
  const _PendingCard({required this.patient});

  final Map<String, dynamic> patient;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.DARK_GREEN.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.DARK_GREEN.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 4.5.h,
            backgroundColor: Colors.white,
            child: Icon(Icons.pending_actions, color: AppColors.DARK_GREEN, size: 20.sp),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient['name'],
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  patient['condition'],
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  'Requested on: ${patient['requestedOn']}',
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  patient['notes'] ?? '',
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Icon(Icons.more_vert, color: Colors.grey[600]),
        ],
      ),
    );
  }
}
