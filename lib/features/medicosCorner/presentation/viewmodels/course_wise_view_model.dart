import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/model/course_wise_model.dart';

class CourseWiseViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CourseWiseModel>> fetchSubjects(String courseTitle) async {
    final snapshot = await _firestore
        .collection('medicos_corner')
        .doc(courseTitle)
        .collection('subjects')
        .get();

    return snapshot.docs
        .map((doc) => CourseWiseModel.fromMap(doc.data()))
        .toList();
  }
}
