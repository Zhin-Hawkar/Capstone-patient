import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/DoctorEditProfile/View/doctor_edit_profile_page.dart';
import 'package:capstone/Patient/Pages/LogIn/Model/sign_in_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DoctorProfileViewPage extends StatefulWidget {
  SignInState doctor;
  DoctorProfileViewPage({super.key, required this.doctor});

  @override
  State<DoctorProfileViewPage> createState() => _DoctorProfileViewPageState();
}

class _DoctorProfileViewPageState extends State<DoctorProfileViewPage> {
  late Map<String, String> _profileData;

  @override
  void initState() {
    super.initState();
    _profileData = {
      'firstName': 'Neha',
      'lastName': 'Patel',
      'location': 'Phoenix, USA',
      'age': '42',
      'specialization': 'Cardiology',
      'department': 'Cardiology',
      'license': 'AZ-45829',
      'experience': '11 years',
      'description':
          'Experienced interventional cardiologist with over 11 years of practice. Specializes in cardiac catheterization, angioplasty, and preventive cardiology. Committed to providing comprehensive cardiac care with a focus on patient education and long-term health outcomes.',
      'qualifications':
          'MD - Internal Medicine, Fellowship - Interventional Cardiology, Board Certified - Cardiology',
      'availability':
          'Monday: 9:00 AM - 5:00 PM, Tuesday: 9:00 AM - 5:00 PM, Wednesday: 9:00 AM - 5:00 PM, Thursday: 9:00 AM - 5:00 PM, Friday: 9:00 AM - 3:00 PM',
      'imageUrl': 'https://i.pravatar.cc/150?img=12',
    };
  }

  void _navigateToEdit() async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(builder: (context) => DoctorEditProfilePage()),
    );

    if (result != null) {
      setState(() {
        _profileData = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final qualifications = _profileData['qualifications']?.split(',') ?? [];

    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: AppBar(
        title: const Text('Doctor Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEdit,
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Column(
            children: [
              _DoctorAvatar(imageUrl: widget.doctor.doctor?.image),
              const SizedBox(height: 12),
              Text(
                'Dr. ${widget.doctor.doctor?.firstName} ${widget.doctor.doctor?.lastName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _DetailSection(
            title: 'Personal information',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  label: 'First name',
                  value: widget.doctor.doctor?.firstName ?? '',
                ),
                _InfoRow(
                  label: 'Last name',
                  value: widget.doctor.doctor?.lastName ?? '',
                ),
                _InfoRow(
                  label: 'Location',
                  value: widget.doctor.doctor?.hospital ?? '',
                ),
                _InfoRow(label: 'Age', value: widget.doctor.doctor?.age),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _DetailSection(
            title: 'Professional information',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  label: 'Specialization',
                  value: widget.doctor.doctor?.specialization ?? '',
                ),
                _InfoRow(
                  label: 'Department',
                  value: widget.doctor.doctor?.department ?? '',
                ),
                _InfoRow(
                  label: 'License number',
                  value: widget.doctor.doctor?.licenseId ?? '',
                ),
                _InfoRow(
                  label: 'Email',
                  value: widget.doctor.doctor?.email ?? '',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _DetailSection(
            title: 'Qualifications',
            child: Text(widget.doctor.doctor?.qualification as String)
          ),
          const SizedBox(height: 20),
          _DetailSection(
            title: 'Availability',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (_profileData['availability']?.split(',') ?? [])
                  .map(
                    (slot) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 18,
                            color: Color(0xFF389D78),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              slot.trim(),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          _DetailSection(
            title: 'Description',
            child: Text(
              widget.doctor.doctor?.description ?? '',
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text("${value}"),
        ],
      ),
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  final String? imageUrl;

  const _DoctorAvatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl ?? Icon(Icons.person);

    return ClipOval(
      child: Container(
        width: 92,
        height: 92,
        color: const Color(0xFFEEF4FF),
        child: imageUrl != null
            ? Image.network(
                "${imageUrl}",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.person,
                  size: 50,
                  color: Color(0xFF389D78),
                ),
              )
            : Icon(Icons.person),
      ),
    );
  }
}
