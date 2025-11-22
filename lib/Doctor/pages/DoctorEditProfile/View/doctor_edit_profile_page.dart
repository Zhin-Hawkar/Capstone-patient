import 'package:flutter/material.dart';

class DoctorEditProfilePage extends StatefulWidget {
  const DoctorEditProfilePage({super.key});

  @override
  State<DoctorEditProfilePage> createState() => _DoctorEditProfilePageState();
}

class _DoctorEditProfilePageState extends State<DoctorEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final Set<String> _selectedDays = {'Mon', 'Tue', 'Thu'};
  bool _telehealthEnabled = true;

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const _SectionCard(
              title: 'Professional information',
              child: Column(
                children: [
                  _ProfileField(
                    label: 'Full name',
                    initialValue: 'Dr. Neha Patel',
                  ),
                  SizedBox(height: 16),
                  _ProfileField(
                    label: 'Specialty',
                    initialValue: 'Cardiology',
                  ),
                  SizedBox(height: 16),
                  _ProfileField(
                    label: 'Medical license',
                    initialValue: 'AZ-45829',
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
                  const Row(
                    children: [
                      Expanded(
                        child: _ProfileField(
                          label: 'Clinic start',
                          initialValue: '08:30 AM',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _ProfileField(
                          label: 'Clinic end',
                          initialValue: '05:00 PM',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _telehealthEnabled,
                    onChanged: (value) {
                      setState(() => _telehealthEnabled = value);
                    },
                    title: const Text('Telehealth appointments'),
                    subtitle: const Text('Allow remote video visits'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _SectionCard(
              title: 'Contact & clinic',
              child: Column(
                children: [
                  _ProfileField(
                    label: 'Primary clinic',
                    initialValue: 'Valley Care Medical Center',
                  ),
                  SizedBox(height: 16),
                  _ProfileField(
                    label: 'Direct contact',
                    initialValue: '(480) 555-2188',
                  ),
                  SizedBox(height: 16),
                  _ProfileField(
                    label: 'Support email',
                    initialValue: 'np-support@valleycare.org',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save profile changes'),
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.initialValue,
  });

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
