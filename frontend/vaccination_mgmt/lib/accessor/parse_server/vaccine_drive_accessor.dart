import 'dart:convert';
import 'dart:core';

import 'package:vaccination_mgmt/model/vaccineDrive.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class VaccineDriveBackendAccessor {
  Future<void> createVaccineDrive(VaccineDrive driveDetails) async {
    final drive = ParseObject('VaccinationDrive')
      ..set('driveName', driveDetails.driveName)
      ..set('driveDt', driveDetails.driveDt.millisecondsSinceEpoch)
      ..set('state', driveDetails.state.name);
    if (driveDetails.vaccineDetails.isNotEmpty) {
      drive.set('vaccineDetails', driveDetails.vaccineDetails);
      drive.set('totalDoses', driveDetails.totalDoses);
    }
    final apiResponse = await drive.save();
    if (apiResponse.success) {
      print("Successfully saved");
    } else {
      print("Error - " + apiResponse.error.toString());
    }
  }

  Future<List<VaccineDrive>> getUpcomingDrives() async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('VaccinationDrive'));
    parseQuery
      ..whereEqualTo('state', DriveState.PENDING.name)
      ..whereGreaterThan('driveDt', DateTime.now().millisecondsSinceEpoch);
    return await _executeQueryAndGetListResult(parseQuery);
  }

  Future<List<VaccineDrive>> getDrivesToApprove() async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('VaccinationDrive'))
          ..whereEqualTo('state', DriveState.DRAFT.name)
          ..whereGreaterThan('driveDt', DateTime.now().millisecondsSinceEpoch);
    return await _executeQueryAndGetListResult(parseQuery);
  }

  Future<List<VaccineDrive>> getNextDrive() async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('VaccinationDrive'))
          ..whereEqualTo('state', DriveState.PENDING.name)
          ..whereGreaterThan('driveDt', DateTime.now().millisecondsSinceEpoch)
          ..orderByAscending('driveDt')
          ..setLimit(1);
    return await _executeQueryAndGetListResult(parseQuery);
  }

  Future<int> countUpcomingDrives() async {
    int count = 0;
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('VaccinationDrive'));
    parseQuery
      ..whereEqualTo('state', DriveState.PENDING.name)
      ..whereGreaterThan('driveDt', DateTime.now().millisecondsSinceEpoch)
      ..count();
    final apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.result != null) {
      count = apiResponse.count;
    }
    return count;
  }

  Future<int> countCompletedDrives() async {
    int count = 0;
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('VaccinationDrive'));
    parseQuery
      ..whereEqualTo('state', DriveState.COMPLETED.name)
      ..count();
    final apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.result != null) {
      count = apiResponse.count;
    }
    return count;
  }

  Future<List<VaccineDrive>> _executeQueryAndGetListResult(
      QueryBuilder<ParseObject> parseQuery) async {
    final apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      List<VaccineDrive> drives = [];
      apiResponse.results
          ?.forEach((element) => drives.add(translateToVaccineDrive(element)));
      return drives;
    } else {
      return [];
    }
  }

  VaccineDrive translateToVaccineDrive(ParseObject parseObject) {
    String? driveName = parseObject.get<String>('driveName');
    int? dateInMillis = parseObject.get<int>('driveDt');

    List<dynamic>? details = parseObject.get<List<dynamic>>('vaccineDetails');
    VaccineDrive drive = VaccineDrive(
        driveName!, DateTime.fromMillisecondsSinceEpoch(dateInMillis!));
    drive.uuid = parseObject.objectId;
    drive.setStateFromString(parseObject.get('state'));
    if (details != null && details.isNotEmpty) {
      details.forEach((element) => drive.addVaccineDetails(
          vaccineName: element['name'], doses: element['doses']));
    }
    return drive;
  }

  Future<void> updateVaccineDrive(VaccineDrive driveDetails) async {
    final drive = ParseObject('VaccinationDrive')
      ..objectId = driveDetails.uuid
      ..set('state', driveDetails.state.name);
    if (driveDetails.vaccineDetails.isNotEmpty) {
      drive.set('vaccineDetails', driveDetails.vaccineDetails);
      drive.set('totalDoses', driveDetails.totalDoses);
    }
    final apiResponse = await drive.save();
    if (apiResponse.success) {
      print("Successfully saved");
    } else {
      print("Error - " + apiResponse.error.toString());
    }
  }
}
