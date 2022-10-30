import 'dart:convert';
import 'dart:core';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

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
}