import 'package:flutter/material.dart';

class DoctorProfileView extends StatelessWidget {
  const DoctorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Column(
            children: [
              const _DoctorAvatar(),
              const SizedBox(height: 12),
              const Text(
                'Dr. Neha Patel',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _DetailSection(
            title: 'Personal information',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: 'First name', value: 'Neha'),
                _InfoRow(label: 'Last name', value: 'Patel'),
                _InfoRow(label: 'Location', value: 'Phoenix, USA'),
                _InfoRow(label: 'Age', value: '42'),
              ],
            ),
          ),
          SizedBox(height: 20),
          _DetailSection(
            title: 'Professional information',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: 'Specialization', value: 'Cardiology'),
                _InfoRow(label: 'Department', value: 'Cardiology'),
                _InfoRow(label: 'License number', value: 'AZ-45829'),
                _InfoRow(label: 'Years of experience', value: '11 years'),
              ],
            ),
          ),
          SizedBox(height: 20),
          _DetailSection(
            title: 'Qualifications',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('MD - Internal Medicine')),
                Chip(label: Text('Fellowship - Interventional Cardiology')),
                Chip(label: Text('Board Certified - Cardiology')),
              ],
            ),
          ),
          SizedBox(height: 20),
          _DetailSection(
            title: 'Description',
            child: Text(
              'Experienced interventional cardiologist with over 11 years of practice. Specializes in cardiac catheterization, angioplasty, and preventive cardiology. Committed to providing comprehensive cardiac care with a focus on patient education and long-term health outcomes.',
              style: TextStyle(fontSize: 15, height: 1.4),
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
          BoxShadow(color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 6)),
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
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  const _DoctorAvatar();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 92,
        height: 92,
        color: const Color(0xFFEEF4FF),
        child: Image.network(
          'https://i.pravatar.cc/150?img=12',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.person,
            size: 50,
            color: Color(0xFF389D78),
          ),
        ),
      ),
    );
  }
}
