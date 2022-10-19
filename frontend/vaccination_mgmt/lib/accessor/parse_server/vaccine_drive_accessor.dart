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
    if(apiResponse.success) {
      print("Successfully saved");
    } else {
      print("Error - "+apiResponse.error.toString());
    }
  }

  Future<List<VaccineDrive>> getUpcomingDrives() async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('VaccinationDrive'));
    parseQuery
      ..whereEqualTo('state', DriveState.PENDING)
      ..whereGreaterThan('driveDt', DateTime.now());
    return _executeQueryAndGetListResult(parseQuery);
  }

  Future<List<VaccineDrive>> getNextDrive() async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('VaccinationDrive'));
    parseQuery
      ..whereEqualTo('state', DriveState.PENDING)
      ..whereGreaterThan('driveDt', DateTime.now())
      ..orderByAscending('driveDt')
      ..setLimit(1);
    return _executeQueryAndGetListResult(parseQuery);
  }

  Future<int> countUpcomingDrives() async {
    int count = 0;
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('VaccinationDrive'));
    parseQuery
      ..whereEqualTo('state', DriveState.PENDING)
      ..whereGreaterThan('driveDt', DateTime.now())
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
      ..whereEqualTo('state', DriveState.COMPLETED)
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

    List<VaccineDetail>? details = parseObject.get<List<VaccineDetail>>('vaccineDetails');
    VaccineDrive drive = VaccineDrive(
        driveName!, DateTime.fromMillisecondsSinceEpoch(dateInMillis!));
    if (details != null && details.isNotEmpty) {
      drive.vaccineDetails = details;
    }
    return drive;
  }
}
