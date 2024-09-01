// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:slam_pakistan_1/Pages/home_page.dart';
import 'dart:convert';

class RegistrationController extends GetxController {
  var serialNumber = ''.obs;
  var applicantName = ''.obs;
  var fatherName = ''.obs;
  var schoolCollege = ''.obs;
  var studentClass = ''.obs;
  var category = ''.obs;
  var contactNumber1 = ''.obs;
  var contactNumber2 = ''.obs;
  var address = ''.obs;
  var dateOfBirth = ''.obs;
  var imagePath = ''.obs;
  var isLoadingImage = false.obs;
  var isSubmitting = false.obs;

  var isFirstTermAccepted = false.obs;
  var isSecondTermAccepted = false.obs;

  html.File? selectedImageFile;

  @override
  void onInit() {
    super.onInit();
    _fetchLatestSerialNumber();
  }

  Future<void> _fetchLatestSerialNumber() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('applications')
          .orderBy('serialNumber', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final latestSerial = snapshot.docs.first.get('serialNumber');
        final serialNumberValue = int.parse(latestSerial.replaceAll('SPO', ''));
        serialNumber.value =
            'SPO${(serialNumberValue + 1).toString().padLeft(3, '0')}';
      } else {
        serialNumber.value = 'SPO001';
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch serial number: $e",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  Future<void> pickImage() async {
    isLoadingImage.value = true;

    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        selectedImageFile = files.first;
        final reader = html.FileReader();

        reader.readAsDataUrl(selectedImageFile!);
        reader.onLoadEnd.listen((e) {
          imagePath.value = reader.result as String;
        });
      }
      isLoadingImage.value = false;
    });
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dateOfBirth.value = "${picked.toLocal()}".split(' ')[0];
    }
  }

  Future<void> submitForm() async {
    if (applicantName.value.isNotEmpty &&
        fatherName.value.isNotEmpty &&
        schoolCollege.value.isNotEmpty &&
        studentClass.value.isNotEmpty &&
        category.value.isNotEmpty &&
        contactNumber1.value.isNotEmpty &&
        address.value.isNotEmpty &&
        dateOfBirth.value.isNotEmpty &&
        imagePath.value.isNotEmpty) {
      try {
        isSubmitting.value = true;

        final reader = html.FileReader();
        reader.readAsArrayBuffer(selectedImageFile!);
        await reader.onLoadEnd.first;

        final imageData = reader.result as List<int>;
        final blob = html.Blob([imageData]);

        String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final storageRef =
            FirebaseStorage.instance.ref().child('applicant_images/$fileName');
        final uploadTask = storageRef.putBlob(blob);

        final snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('applications').add({
          'serialNumber': serialNumber.value,
          'applicantName': applicantName.value,
          'fatherName': fatherName.value,
          'schoolCollege': schoolCollege.value,
          'studentClass': studentClass.value,
          'category': category.value,
          'contactNumber1': contactNumber1.value,
          'contactNumber2': contactNumber2.value,
          'address': address.value,
          'dateOfBirth': dateOfBirth.value,
          'imageUrl': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Generate PDF
        final pdf = await generatePdf(downloadUrl);

        // Upload PDF to Firebase
        await uploadPdfToFirebase(pdf);

        // Trigger PDF download in browser
        triggerPdfDownload(pdf);

        Get.dialog(
          AlertDialog(
            title: const Text('Application Submitted'),
            content: Text(
                'Your application has been submitted successfully.\nSerial Number: ${serialNumber.value}'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.offAll(const LandingPage());
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        Get.snackbar("Error", "Failed to submit application: $e",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      } finally {
        isSubmitting.value = false;
      }
    } else {
      Get.snackbar("Error", "Please fill all the fields!",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  Future<pw.Document> generatePdf(String imageUrl) async {
    final pdf = pw.Document();

    final netImage = await networkImage(imageUrl);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Application Receipt',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Serial Number: ${serialNumber.value}'),
              pw.Text('Applicant Name: ${applicantName.value}'),
              pw.Text('Father Name: ${fatherName.value}'),
              pw.Text('School/College: ${schoolCollege.value}'),
              pw.Text('Class: ${studentClass.value}'),
              pw.Text('Category: ${category.value}'),
              pw.Text('Date of Birth: ${dateOfBirth.value}'),
              pw.Text('Contact Number 1: ${contactNumber1.value}'),
              pw.Text('Contact Number 2: ${contactNumber2.value}'),
              pw.Text('Address: ${address.value}'),
              pw.SizedBox(height: 20),
              pw.Text('Applicant Photo:'),
              pw.SizedBox(height: 10),
              pw.Image(netImage, width: 200, height: 200),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  Future<void> uploadPdfToFirebase(pw.Document pdf) async {
    final pdfData = await pdf.save();
    final pdfBlob = html.Blob([pdfData]);

    String pdfFileName = '${serialNumber.value}.pdf';
    final pdfRef =
        FirebaseStorage.instance.ref().child('applicant_pdfs/$pdfFileName');
    await pdfRef.putBlob(pdfBlob);
  }

  void triggerPdfDownload(pw.Document pdf) async {
    final pdfData = await pdf.save();
    final blob = html.Blob([pdfData], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "${serialNumber.value}.pdf")
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
