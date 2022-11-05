import 'package:intl/intl.dart';

class StudentDetails {
  final String id;
  final String name;
  String? aadhar = null;
  DateTime? dob = null;
  bool isVaccinated = false;
  String? uuid;
  List<DoseDetail> _doseDetails = [];

  StudentDetails(this.id, this.name , this.aadhar, this.dob);
  final DateFormat dtFormatter = DateFormat('dd-MM-yyyy');
  void addDoseDetail(DoseDetail detail) {
    _doseDetails.add(detail);
  }

  List<DoseDetail> get doseDetails {
    return this._doseDetails;
  }

  String prettyPrintDoseDetails() {
    String? name;
    DateTime? dose1Dt;
    DateTime? dose2Dt;
    String out = "Vaccination Details Unavailable";

    if(_doseDetails != null) {
      _doseDetails.forEach((element) {

        name = element.vaccineName;
        if (element.doseNo == 1 && element.doseDt !=null) {
          try {
            dose1Dt = DateTime.fromMillisecondsSinceEpoch(element.doseDt);
          } catch(e) {
print('dt formatitng error');
          }
        }
        if (element.doseNo == 2 && element.doseDt != null) {
          try {
            dose2Dt = DateTime.fromMillisecondsSinceEpoch(element.doseDt);
          }catch(e) {
            print('dt formatitng error');
          }
        }
      });

      if (name != null && name!.isNotEmpty) {
        out = name! + " on ";
        if(dose1Dt != null) {
          out+= dtFormatter.format(dose1Dt!);
        } else {
          out+= "NA";
        }
        if (dose2Dt != null) {
          out += "  &  " + dtFormatter.format(dose2Dt!);
        }
      }
    }
    return out;
  }
}

class DoseDetail {
  final String vaccineName;
  final int doseNo;
  final int doseDt;
  String? batchNo = "";

  DoseDetail(this.vaccineName, this.doseNo, this.doseDt, {this.batchNo});

  factory DoseDetail.fromJson(dynamic json) {
    DoseDetail dd = DoseDetail(
        json['name'] as String, json['doseNo'] as int, json['date'] as int);
    return dd;
  }

  Map toJson() => {
    'name': this.vaccineName,
    'doseNo': this.doseNo,
    'date': this.doseDt,
    'batchNo': this.batchNo,
  };
}