Parse.Cloud.beforeSave("StudentVaccinationDetails", (request) => {
  const studentDetails = request.object;
  var vaccineDetails = studentDetails.get("doseDetails")
  if(vaccineDetails != null && vaccineDetails.trim().length > 0) {
    studentDetails.set("isVaccinated", true);
	studentDetails.set("noOfDoses", vaccineDetails.length);
	vaccineDetails.sort((e1, e2) => e1.doseNo - e2.doseNo);
    var detail = vaccineDetails[vaccineDetails.length-1];
    studentDetails.set("lastVaccineDt", detail.date);
    studentDetails.set("primaryVaccineName", vaccineDetails[0].name);
  }
}
);