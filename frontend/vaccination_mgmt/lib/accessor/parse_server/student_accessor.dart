import 'dart:convert';
import 'dart:core';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:vaccination_mgmt/model/studentDetails.dart';

class StudentBackendAccessor {
  Future<int> getTotalStudents() async {
    int count = 0;
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('StudentVaccinationDetails'))
          ..count();
    final apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.result != null) {
      count = apiResponse.count;
    }
    return count;
  }

  Future<int> getTotalVaccinatedStudents() async {
    int count = 0;
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('StudentVaccinationDetails'))
          ..whereEqualTo('isVaccinated', true)
          ..count();
    final apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.result != null) {
      count = apiResponse.count;
    }
    return count;
  }

  Future<int> getVaccinatedInSchoolCount() async {
    int count = 0;
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('StudentVaccinationDetails'))
          ..whereValueExists('schoolDriveId', true)
          ..count();
    final apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.result != null) {
      count = apiResponse.count;
    }
    return count;
  }

  Future<int> getCountByVaccine(String vaccineName) async {
    int count = 0;
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('StudentVaccinationDetails'))
          ..whereEqualTo('doseDetails.name', vaccineName)
          ..count();
    final apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.result != null) {
      count = apiResponse.count;
    }
    return count;
  }

  Future<void> createNewStudent(StudentDetails student) async {
    final pStudent = ParseObject('StudentVaccinationDetails')
      ..set('studentId', student.id)
      ..set('name', student.name)
      ..set('dob', student.dob?.millisecondsSinceEpoch)
      ..set('isVaccinated', student.isVaccinated)
      ..set('aadharNo', student.aadhar);

    final apiResponse = await pStudent.save();
    if (apiResponse.success) {
      print("Successfully saved");
    } else {
      print("Error - " + apiResponse.error.toString());
    }
  }

  Future<List<StudentDetails>> getAllStudents() async {
    final apiResponse = await ParseObject('StudentVaccinationDetails').getAll();

    List<StudentDetails> students = [];
    if (apiResponse.success && apiResponse.results != null) {
      apiResponse.results?.forEach((element) {
        String? studentId = element.get<String>('studentId');
        String? name = element.get<String>('name');
        String? aadhar = element.get<String>('aadharNo');
        int? dob = element.get<int>('dob');

        StudentDetails student = StudentDetails(studentId!, name!, aadhar,
            DateTime.fromMillisecondsSinceEpoch(dob != null ? dob : 0));
        student.uuid = (element as ParseObject).objectId;
        student.isVaccinated = element.get<bool>('isVaccinated')!;
        students.add(student);
      });
    }
    return students;
  }
}
