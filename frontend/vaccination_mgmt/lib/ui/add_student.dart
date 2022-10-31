import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:vaccination_mgmt/model/studentDetails.dart';
import 'package:vaccination_mgmt/model/vaccineDrive.dart';
import 'package:vaccination_mgmt/accessor/parse_server/vaccine_drive_accessor.dart';
import 'package:vaccination_mgmt/accessor/parse_server/student_accessor.dart';
import 'package:intl/intl.dart';

class AddNewStudentWidget extends StatefulWidget {
  const AddNewStudentWidget({Key? key}) : super(key: key);

  @override
  AddNewStudentState createState() => AddNewStudentState();
}

class AddNewStudentState extends State<AddNewStudentWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormBuilderState>();
  final DateFormat dtFormatter = DateFormat('dd-MM-yyyy');

  void saveStudentDetails() async {
    var studentForm = _formKey.currentState?.value;
    debugPrint(_formKey.currentState?.value['studentId']);
    debugPrint(_formKey.currentState?.value['stdDOB'].toString());

    StudentDetails student = StudentDetails(studentForm?['studentId'], studentForm?['stdName'], studentForm?['aadharNo'], studentForm?['stdDOB']);
    student.isVaccinated = studentForm?['isVaccinated'];

    StudentBackendAccessor().createNewStudent(student);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Student Details Saved Successfully"),
      duration: Duration(seconds: 2),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 14),
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.black54,
                            size: 30,
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                  child: Text(
                    'Add Student Details',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black54,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(-0.05, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
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

                              // valueTransformer: (text) => num.tryParse(text),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter value for StudentId";
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
                              name: 'stdName',
                              decoration: InputDecoration(
                                labelText: 'Name',
                              ),

                              // valueTransformer: (text) => num.tryParse(text),
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

                              // valueTransformer: (text) => num.tryParse(text),
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
                              initialValue: DateTime.now(),
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
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                            child: FormBuilderCheckbox(
                              name: 'isVaccinated',
                              initialValue: false,
                              title: Text(
                                'Already Vaccinated ?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
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
                                saveStudentDetails();
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
                        const SizedBox(width: 20),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                          child: OutlinedButton(
                            onPressed: () {
                              _formKey.currentState?.reset();
                            },
                            // color: Theme.of(context).colorScheme.secondary,
                            child: Text(
                              'Reset',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
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
      ),
    );
  }
}
