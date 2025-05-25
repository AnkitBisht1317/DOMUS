import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAcademicDetails {
  final String batch;
  final String collegeState;
  final String collegeName;
  final Timestamp timestamp;

  StudentAcademicDetails({
    required this.batch,
    required this.collegeState,
    required this.collegeName,
    Timestamp? timestamp,
  }) : timestamp = timestamp ?? Timestamp.now();

  Map<String, dynamic> toMap() {
    return {
      'batch': batch,
      'collegeState': collegeState,
      'collegeName': collegeName,
      'timestamp': timestamp,
    };
  }

  factory StudentAcademicDetails.fromMap(Map<String, dynamic> map) {
    return StudentAcademicDetails(
      batch: map['batch'] as String,
      collegeState: map['collegeState'] as String,
      collegeName: map['collegeName'] as String,
      timestamp: map['timestamp'] as Timestamp,
    );
  }
} 