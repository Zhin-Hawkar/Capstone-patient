import 'package:capstone/Patient/Pages/Feedback/View/review_form_page.dart';
import 'package:capstone/Patient/Pages/Hospital/Model/hospital.dart';
import 'package:flutter/material.dart';

class HospitalProfilePage extends StatelessWidget {
  final Hospital? hospital;
  const HospitalProfilePage({super.key, this.hospital});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const darkGreen = Color(0xFF4B8A6C);
    const lightGreen = Color(0xFFC2E0D2);

    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 260,
              child: Image.network(
                "${hospital?.image}",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(
                    Icons.local_hospital,
                    size: 64,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          // Back button on image (top-left)
          Positioned(
            top: topInset + 6,
            left: 8,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
                tooltip: 'Back',
              ),
            ),
          ),

          // White rounded content
          Positioned.fill(
            top: 220,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Button aligned right
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ReviewFormPage(hospital: hospital),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Write a review'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6), // name sits higher
                    Text(
                      "${hospital?.hospitalName}",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.05,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_city, size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "${hospital?.description}",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              decoration: TextDecoration.underline,
                              decorationThickness: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    Text(
                      "${hospital?.location}",
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                    ),

                    const SizedBox(height: 26),
                    Center(
                      child: Text(
                        'Charité Centers:',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Container(
                      decoration: BoxDecoration(
                        color: lightGreen,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // for (final c in hospital.centers)
                          //   Padding(
                          //     padding: const EdgeInsets.symmetric(vertical: 10),
                          //     child: Row(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         const Padding(
                          //           padding: EdgeInsets.only(top: 8),
                          //           child: Icon(Icons.circle, size: 8),
                          //         ),
                          //         const SizedBox(width: 14),
                          //         Expanded(
                          //           child: Text(
                          //             c,
                          //             style: theme.textTheme.titleMedium
                          //                 ?.copyWith(height: 1.4),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
