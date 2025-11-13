import 'package:capstone/Patient/Pages/Hospital/Model/hospital.dart';
import 'package:flutter/material.dart';

class ReviewFormPage extends StatefulWidget {
  final Hospital? hospital;
  const ReviewFormPage({super.key,  this.hospital});

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _doctor = TextEditingController();
  final _comments = TextEditingController();
  int _rating = 4;

  @override
  void dispose() {
    _name.dispose();
    _doctor.dispose();
    _comments.dispose();
    super.dispose();
  }

  InputDecoration _roundedInput({required String hint, IconData? icon}) {
    const radius = 18.0;
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: Color(0xFF4B8A6C), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xFF4B8A6C);
    const bgTop = Color(0xFFE9F4EE);
    const bgBottom = Color(0xFFDCEFE6);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: Stack(
          children: [
            // Back arrow on gradient
            Positioned(
              left: 8,
              top: MediaQuery.of(context).padding.top + 4,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Rounded white form card
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 56,
                left: 16, right: 16, bottom: 16,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'Write a Review',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 26),

                        Text('Name:', style: theme.textTheme.titleSmall),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _name,
                          decoration: _roundedInput(hint: 'Your name', icon: Icons.person_outline),
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),

                        const SizedBox(height: 18),
                        Text('Review About:', style: theme.textTheme.titleSmall),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _doctor,
                          decoration: _roundedInput(hint: "Enter Doctor's Name", icon: Icons.badge_outlined),
                        ),

                        const SizedBox(height: 22),
                        Text(
                          'Share your experience in scaling',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        _StarRating(
                          value: _rating,
                          size: 32,
                          onChanged: (v) => setState(() => _rating = v),
                        ),

                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _comments,
                          minLines: 5, maxLines: 6,
                          textInputAction: TextInputAction.newline,
                          decoration: _roundedInput(hint: 'Add your comments...'),
                        ),

                        const SizedBox(height: 26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                foregroundColor: darkGreen,
                                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 2,
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() != true) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Review submitted!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              child: const Text('SUBMIT'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final int value;
  final double size;
  final ValueChanged<int> onChanged;

  const _StarRating({
    required this.value,
    required this.onChanged,
    this.size = 28,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const filledColor = Colors.amber; // yellow
    const emptyColor = Color(0xFF9CA3AF); // gray

    return Row(
      children: List.generate(5, (i) {
        final idx = i + 1;
        final isFilled = idx <= value;
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          iconSize: size,
          onPressed: () => onChanged(idx),
          icon: Icon(
            isFilled ? Icons.star_rounded : Icons.star_border_rounded,
            color: isFilled ? filledColor : emptyColor,
          ),
        );
      }),
    );
  }
}
