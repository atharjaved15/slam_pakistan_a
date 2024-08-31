import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:slam_pakistan_1/data_model.dart';

class ReceiptScreen extends StatelessWidget {
  final ApplicationForm application;

  const ReceiptScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Receipt'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Receipt for Application #${application.serialNumber}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text('Name: ${application.name}',
                style: const TextStyle(fontSize: 18)),
            Text("Father's Name: ${application.fatherName}",
                style: const TextStyle(fontSize: 18)),
            Text(
                'Date of Birth: ${application.dob.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 18)),
            Text('School/College: ${application.schoolCollege}',
                style: const TextStyle(fontSize: 18)),
            Text('Class: ${application.studentClass}',
                style: const TextStyle(fontSize: 18)),
            Text('Category: ${application.category}',
                style: const TextStyle(fontSize: 18)),
            Text('Contact #1: ${application.contact1}',
                style: const TextStyle(fontSize: 18)),
            if (application.contact2.isNotEmpty)
              Text('Contact #2: ${application.contact2}',
                  style: const TextStyle(fontSize: 18)),
            Text('Address: ${application.address}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _downloadReceipt(application);
              },
              child: const Text('Download Receipt'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadReceipt(ApplicationForm application) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Receipt for Application #${application.serialNumber}',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Name: ${application.name}',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.Text("Father's Name: ${application.fatherName}",
                  style: const pw.TextStyle(fontSize: 18)),
              pw.Text(
                  'Date of Birth: ${application.dob.toLocal().toString().split(' ')[0]}',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.Text('School/College: ${application.schoolCollege}',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.Text('Class: ${application.studentClass}',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.Text('Category: ${application.category}',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.Text('Contact #1: ${application.contact1}',
                  style: const pw.TextStyle(fontSize: 18)),
              if (application.contact2.isNotEmpty)
                pw.Text('Contact #2: ${application.contact2}',
                    style: const pw.TextStyle(fontSize: 18)),
              pw.Text('Address: ${application.address}',
                  style: const pw.TextStyle(fontSize: 18)),
            ],
          );
        },
      ),
    );

    final fileName = 'application_receipt_${application.serialNumber}.pdf';
    await Printing.sharePdf(bytes: await pdf.save(), filename: fileName);
  }
}
