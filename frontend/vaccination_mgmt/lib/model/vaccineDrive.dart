import 'dart:convert';

enum DriveState { DRAFT , PENDING, COMPLETED }
class VaccineDrive {
  final String driveName;
  final DateTime driveDt;
  bool _isPreApproved = false;
  int _totalDoses = 0;
  DriveState _state = DriveState.DRAFT;
  List<VaccineDetail> _vaccineDetails = [];

  VaccineDrive(this.driveName, this.driveDt);

  set isPreApproved(bool value) {
    this._isPreApproved = value;
  }

  DriveState get state {
    if(this._isPreApproved) {
      _state = DriveState.PENDING;
    }
    return _state;
  }

  void addVaccineDetails({required String vaccineName, required int doses}) {
    _vaccineDetails.add(VaccineDetail(vaccineName, doses));
  }

  List<VaccineDetail> get vaccineDetails {
    return _vaccineDetails;
  }

  int get totalDoses {
    _vaccineDetails.forEach((element) => _totalDoses+= element.noOfDoses);
    return _totalDoses;
  }

  void set vaccineDetails(List<VaccineDetail> details) {
    _vaccineDetails = details;
  }
}

class VaccineDetail {
  final String vaccineName;
  final int noOfDoses;

  VaccineDetail(this.vaccineName, this.noOfDoses);

  Map toJson() => {
    'name': this.vaccineName,
    'doses': this.noOfDoses,
  };
}