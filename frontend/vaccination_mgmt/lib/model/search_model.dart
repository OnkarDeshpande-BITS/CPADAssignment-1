class SearchFilter {
  String? isVaccinated;
  String? vaccineName;
  String? driveId;
  DateTime? startDt;
  DateTime? endDt;

  SearchFilter(
      {this.vaccineName,
      this.isVaccinated,
      this.driveId,
      this.startDt,
      this.endDt});
}
