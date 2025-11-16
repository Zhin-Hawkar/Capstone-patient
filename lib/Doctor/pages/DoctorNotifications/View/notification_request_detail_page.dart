import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Controller/doctor_notification.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Model/doctor_notification.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Notifier/doctor_notification_response%20copy.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Notifier/patient_notification_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientRequestDetail {
  const PatientRequestDetail({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.email,
    required this.department,
    required this.dateTime,
    required this.helpSummary,
    required this.aiAnalysis,
    this.photoUrl,
  });

  final String firstName;
  final String lastName;
  final String age;
  final String gender;
  final String email;
  final String department;
  final String dateTime;
  final String helpSummary;
  final String aiAnalysis;
  final String? photoUrl;
}

class NotificationRequestDetailPage extends ConsumerStatefulWidget {
  const NotificationRequestDetailPage({super.key, required this.detail});

  final DoctorNotification detail;

  @override
  ConsumerState<NotificationRequestDetailPage> createState() =>
      _NotificationRequestDetailPageState();
}

class _NotificationRequestDetailPageState
    extends ConsumerState<NotificationRequestDetailPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      doctorNotificationResponseNotifierProvider.notifier,
    );
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: AppBar(
        title: const Text('Request details'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: widget.detail.status == "pending"
                ? FilledButton(
                    onPressed: () => _openRespondDialog(context, state),
                    child: const Text('Respond'),
                  )
                : FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        AppColors.DARK_GREEN,
                      ),
                    ),
                    onPressed: () => {},
                    child: const Text('Responded'),
                  ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _PatientAvatar(detail: widget.detail),
          const SizedBox(height: 20),
          _InfoField(
            label: 'First name',
            value: widget.detail.firstName.toString(),
          ),
          _InfoField(
            label: 'Last name',
            value: widget.detail.lastName.toString(),
          ),
          _InfoField(label: 'Age', value: widget.detail.age.toString()),
          _InfoField(label: 'Gender', value: widget.detail.gender.toString()),
          _InfoField(label: 'Email', value: widget.detail.email.toString()),
          _InfoField(
            label: 'Health sector / department',
            value: widget.detail.department.toString(),
          ),
          _InfoField(
            label: 'Date time',
            value: widget.detail.date_time!.toIso8601String(),
          ),
          _InfoField(
            label: 'Patient concerns',
            value: widget.detail.help.toString(),
            isMultiline: true,
          ),
          const SizedBox(height: 24),
          _AiInsightCard(detail: widget.detail.aiAnalysis.toString()),
        ],
      ),
    );
  }

  void _openRespondDialog(
    BuildContext context,
    DoctorNotificationResponseNotifier state,
  ) {
    showDialog(
      context: context,
      builder: (_) => RespondDialog(
        ref: ref,
        patientId: widget.detail.patientId,
        firstName: widget.detail.firstName.toString(),
        lastName: widget.detail.lastName.toString(),
        state: state,
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  String label;
  String value;
  final bool isMultiline;
  _InfoField({
    this.isMultiline = false,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${label}",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            "${value}",
            style: TextStyle(
              fontSize: 15,
              height: isMultiline ? 1.4 : 1.2,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _AiInsightCard extends StatelessWidget {
  _AiInsightCard({required this.detail});

  String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF7F5AF0), Color(0xFFA277FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x335E35B1),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'AI analysed description',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "${detail}",
            style: const TextStyle(color: Colors.white, height: 1.4),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class RespondDialog extends StatefulWidget {
  RespondDialog({
    super.key,
    required this.ref,
    required this.firstName,
    required this.patientId,
    required this.lastName,
    required this.state,
  });
  DoctorNotificationResponseNotifier state;
  WidgetRef ref;
  final String firstName;
  final String lastName;
  final int? patientId;

  @override
  State<RespondDialog> createState() => _RespondDialogState();
}

class _RespondDialogState extends State<RespondDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Respond to ${widget.firstName} ${widget.lastName}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                minLines: 4,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Write your response...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        widget.ref
                            .watch(
                              doctorNotificationResponseNotifierProvider
                                  .notifier,
                            )
                            .setPatientId(widget.patientId);
                        widget.ref
                            .watch(
                              doctorNotificationResponseNotifierProvider
                                  .notifier,
                            )
                            .setComment(_controller.text);
                        final result =
                            await DoctorNotificationController.handleRejectedDoctorResponse(
                              widget.ref,
                            );
                        if (result == 200) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          setState(() => {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "response has been sent successfuly",
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'reject',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.DARK_GREEN,
                        ),
                      ),

                      onPressed: () async {
                        widget.ref
                            .watch(
                              doctorNotificationResponseNotifierProvider
                                  .notifier,
                            )
                            .setPatientId(widget.patientId);
                        widget.ref
                            .watch(
                              doctorNotificationResponseNotifierProvider
                                  .notifier,
                            )
                            .setComment(_controller.text);
                        final result =
                            await DoctorNotificationController.handleApprovedDoctorResponse(
                              widget.ref,
                            );
                        if (result == 200) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          setState(() => {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "response has been sent successfuly",
                              ),
                            ),
                          );
                        }
                      },

                      child: const Text(
                        'approve',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
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

class _PatientAvatar extends StatelessWidget {
  const _PatientAvatar({required this.detail});

  final DoctorNotification detail;

  @override
  Widget build(BuildContext context) {
    final initials =
        '${detail.firstName ?? ''}'
        '${detail.lastName ?? ''}';
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xFFEEF4FF),
          backgroundImage: detail.image != null
              ? NetworkImage(detail.image!)
              : null,
          child: detail.image == null
              ? Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF389D78),
                  ),
                )
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          '${detail.firstName} ${detail.lastName}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
