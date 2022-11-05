import 'dart:convert';
import 'dart:core';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:vaccination_mgmt/model/search_model.dart';
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

    if (student.isVaccinated) {
      pStudent.set('doseDetails', student.doseDetails);
    }
    final apiResponse = await pStudent.save();
    if (apiResponse.success) {
      print("Successfully saved");
    } else {
      print("Error - " + apiResponse.error.toString());
    }
  }

  Future<List<StudentDetails>> getAllStudents(
      SearchFilter? searchFilter) async {
    if (searchFilter != null) {
      if (searchFilter.isVaccinated != null &&
          searchFilter.isVaccinated == 'No') {
        final QueryBuilder<ParseObject> parseQuery =
            QueryBuilder<ParseObject>(ParseObject('StudentVaccinationDetails'));
        parseQuery.whereEqualTo('isVaccinated', false);
        final apiResponse = await parseQuery.query();
        List<StudentDetails> details = extractStudents(apiResponse);

        return details;
      } else {
        return await getStudentsWithCompoundQuery(searchFilter);
      }
    }
    final ParseResponse apiResponse =
        await ParseObject('StudentVaccinationDetails').getAll();
    return extractStudents(apiResponse);
  }

  Future<List<StudentDetails>> getStudentsWithCompoundQuery(
      SearchFilter searchFilter) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('StudentVaccinationDetails'));
    if (searchFilter.vaccineName != null) {
      parseQuery.whereEqualTo('doseDetails.name', searchFilter.vaccineName);
    }
    if (searchFilter.driveId != null) {
      parseQuery.whereEqualTo('schoolDriveId', searchFilter.driveId);
    } else if (searchFilter.startDt != null) {}
    final apiResponse = await parseQuery.query();
    return extractStudents(apiResponse);
  }

  List<StudentDetails> extractStudents(ParseResponse apiResponse) {

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
        List<dynamic>? details = element.get<List<dynamic>>('doseDetails');
        if (details != null && details.isNotEmpty) {
          details.forEach(
              (json) => student.addDoseDetail(DoseDetail.fromJson(json)));
        }
        students.add(student);
      });
    }
    return students;
  }

  Future<void> updateStudent(StudentDetails student) async {
    final drive = ParseObject('StudentVaccinationDetails')
      ..objectId = student.uuid
      ..set('name', student.name)
      ..set('dob', student.dob?.millisecondsSinceEpoch)
      ..set('aadharNo', student.aadhar)
      ..set('doseDetails', student.doseDetails);

    final apiResponse = await drive.save();
    if (apiResponse.success) {
      print("Successfully saved");
    } else {
      print("Error - " + apiResponse.error.toString());
    }
  }
}
