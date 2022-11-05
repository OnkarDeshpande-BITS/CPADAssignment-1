import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:vaccination_mgmt/accessor/parse_server/student_accessor.dart';
import 'package:vaccination_mgmt/model/studentDetails.dart';
import 'package:intl/intl.dart';
import 'package:vaccination_mgmt/model/vaccine_type.dart';

class EditStudentWidget extends StatefulWidget {
  final StudentDetails edit_details;

  const EditStudentWidget({
    super.key,
    required this.edit_details,
  });

  @override
  EditStudentState createState() => EditStudentState(edit_details);
}

class EditStudentState extends State<EditStudentWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormBuilderState>();
  final DateFormat dtFormatter = DateFormat('dd-MM-yyyy');
  final StudentDetails _edit_details;
  String? vaccineName;
  DateTime? dose1Dt;
  DateTime? dose2Dt;

  EditStudentState(this._edit_details);

  void updateDriveDetails() async {
    var studentForm = _formKey.currentState?.value;
    StudentDetails student = StudentDetails(
        _edit_details.id,
        studentForm?['stdName'],
        studentForm?['aadharNo'],
        studentForm?['stdDOB']);
    bool vaccinated = _edit_details.isVaccinated;
    student.isVaccinated = vaccinated;
student.uuid = _edit_details.uuid;
    String vaccineName = studentForm?['vaccineName'];
    if (vaccineName != null && vaccineName.isNotEmpty) {
      DateTime dose1dt = studentForm?['dose1Dt'];
      if (dose1dt != null) {
        DoseDetail detail1 =
            DoseDetail(vaccineName, 1, dose1dt.millisecondsSinceEpoch);
        student.addDoseDetail(detail1);
      }
      DateTime dose2dt = studentForm?['dose2Dt'];
      if (dose2dt != null) {
        DoseDetail detail2 =
            DoseDetail(vaccineName, 2, dose2dt.millisecondsSinceEpoch);
        student.addDoseDetail(detail2);
      }
    }
    StudentBackendAccessor().updateStudent(student);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Drive Successfully Saved"),
      duration: Duration(seconds: 2),
    ));
    Navigator.pop(context);
  }

  void setDoseFields() {
    List<DoseDetail> doseDetail = _edit_details.doseDetails;
    if (doseDetail != null && doseDetail.length > 0) {
      doseDetail.forEach((element) {
        vaccineName = element.vaccineName;
        if (element.doseNo == 1) {
          dose1Dt = DateTime.fromMillisecondsSinceEpoch(element.doseDt);
        } else if (element.doseNo == 2) {
          dose2Dt = DateTime.fromMillisecondsSinceEpoch(element.doseDt);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setDoseFields();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.black54,
                          size: 25,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'Modify Student Details',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black54,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(-0.05, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FormBuilder(
                      key: _formKey,
                      // enabled: false,

                      autovalidateMode: AutovalidateMode.disabled,

                      skipDisabled: true,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: FormBuilderTextField(
                              name: 'studentId',
                              decoration: InputDecoration(
                                labelText: 'StudentId / Rollno',
                              ),
                              initialValue: _edit_details.id,
                              enabled: false,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: FormBuilderTextField(
                              name: 'stdName',
                              decoration: InputDecoration(
                                labelText: 'Name',
                              ),
                              initialValue: _edit_details.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter value for Student Name";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: FormBuilderTextField(
                              name: 'aadharNo',
                              decoration: InputDecoration(
                                labelText: 'Aadhar Number',
                              ),
                              initialValue: _edit_details.aadhar,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: FormBuilderDateTimePicker(
                              name: 'stdDOB',
                              initialEntryMode: DatePickerEntryMode.calendar,
                              initialValue: _edit_details.dob,
                              inputType: InputType.date,
                              format: dtFormatter,
                              decoration: InputDecoration(
                                labelText: 'Date of Birth',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _formKey.currentState!.fields['stdDOB']
                                        ?.didChange(null);
                                  },
                                ),
                              ),
                            ),
                          ),
                          if (vaccineName != null &&
                              vaccineName!.isNotEmpty) ...[
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                              child: FormBuilderTextField(
                                name: 'vaccineName',
                                decoration: InputDecoration(
                                  labelText: 'VaccineName',
                                ),
                                initialValue: vaccineName,
                              ),
                            ),
                          ] else ...[
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                              child: FormBuilderDropdown<String>(
                                name: 'vaccineName',
                                decoration: InputDecoration(
                                  labelText: 'VaccineName',
                                  hintText: 'Select Vaccine',
                                ),
                                items: VaccineType.values
                                    .map((type) => DropdownMenuItem(
                                          alignment:
                                              AlignmentDirectional.center,
                                          value: type.name,
                                          child: Text(type.name),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: FormBuilderDateTimePicker(
                              name: 'dose1Dt',
                              initialEntryMode: DatePickerEntryMode.calendar,
                              inputType: InputType.date,
                              resetIcon: null,
                              format: dtFormatter,
                              initialValue: dose1Dt,
                              decoration: InputDecoration(
                                labelText: 'Dose1 Date',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _formKey.currentState!.fields['dose1Dt']
                                        ?.didChange(null);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: FormBuilderDateTimePicker(
                              name: 'dose2Dt',
                              initialEntryMode: DatePickerEntryMode.calendar,
                              resetIcon: null,
                              inputType: InputType.date,
                              initialValue: dose2Dt,
                              format: dtFormatter,
                              decoration: InputDecoration(
                                labelText: 'Dose2 Date',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _formKey.currentState!.fields['dose2Dt']
                                        ?.didChange(null);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _formKey.currentState!.save();
                                debugPrint(
                                    _formKey.currentState?.value.toString());
                                updateDriveDetails();
                              } else {
                                debugPrint('validation failed');
                              }
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
