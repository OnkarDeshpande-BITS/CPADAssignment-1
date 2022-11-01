class StudentDetails {
  final String id;
  final String name;
  String? aadhar = null;
  DateTime? dob = null;
  bool isVaccinated = false;
  String? uuid;

  StudentDetails(this.id, this.name , this.aadhar, this.dob);


}