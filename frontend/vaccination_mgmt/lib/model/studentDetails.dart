class StudentDetails {
  final String id;
  final String name;
  String? aadhar = null;
  DateTime? dob = null;
  bool isVaccinated = false;
  String? uuid;
  List<DoseDetail> _doseDetails = [];

  StudentDetails(this.id, this.name , this.aadhar, this.dob);

  void addDoseDetail(DoseDetail detail) {
    _doseDetails.add(detail);
  }

  List<DoseDetail> get doseDetails {
    return this._doseDetails;
  }
}

class DoseDetail {
  final String vaccineName;
  final int doseNo;
  final int doseDt;
  String batchNo = "";

  DoseDetail(this.vaccineName, this.doseNo, this.doseDt, this.batchNo);

  factory DoseDetail.fromJson(dynamic json) {
    return DoseDetail(
        json['name'] as String, json['doseNo'] as int, json['date'] as int, json['batchNo'] as String);
  }

  Map toJson() => {
    'name': this.vaccineName,
    'doseNo': this.doseNo,
    'date': this.doseDt,
    'batchNo': this.batchNo,
  };
}