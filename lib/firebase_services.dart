// ignore: depend_on_referenced_packages, avoid_web_libraries_in_flutter
import 'dart:js';

// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:slam_pakistan_1/data_model.dart'; // Assuming the model file is named 'application_form.dart'

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addApplication(ApplicationForm application) async {
    try {
      await _firestore.collection('applications').add(application.toMap());
      if (kDebugMode) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text('Failed to generate serial number.')),
        );
        print('Application added successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to add application: $e');
      }
    }
  }
}
