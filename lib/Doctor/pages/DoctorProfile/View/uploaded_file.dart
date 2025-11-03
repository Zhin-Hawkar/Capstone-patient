import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadedFile extends ConsumerStatefulWidget {
  const UploadedFile({super.key});

  @override
  ConsumerState<UploadedFile> createState() => _UploadedFileState();
}

class _UploadedFileState extends ConsumerState<UploadedFile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}