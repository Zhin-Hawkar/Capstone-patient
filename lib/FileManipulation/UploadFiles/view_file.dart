import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileViewer extends StatelessWidget {
  final String pdfUrl;
  const FileViewer({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: SfPdfViewer.network(pdfUrl));
  }
}
