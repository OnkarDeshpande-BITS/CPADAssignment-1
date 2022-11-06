import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vaccination_mgmt/model/search_model.dart';
import 'package:vaccination_mgmt/model/vaccineDrive.dart';
import 'package:vaccination_mgmt/model/vaccine_type.dart';
import 'package:vaccination_mgmt/ui/student_search.dart';
import 'package:vaccination_mgmt/ui/templates/action_row.dart';
import 'package:vaccination_mgmt/ui/new_drive.dart';
import 'package:vaccination_mgmt/accessor/parse_server/vaccine_drive_accessor.dart';
import 'package:intl/intl.dart';
import 'package:vaccination_mgmt/ui/drive_list_view.dart';
import 'package:vaccination_mgmt/ui/drive_edit.dart';
import 'package:vaccination_mgmt/ui/add_student.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:vaccination_mgmt/accessor/parse_server/student_file_uploader.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GenerateReportsWidget extends StatefulWidget {
  const GenerateReportsWidget({Key? key}) : super(key: key);

  @override
  _GenerateReportState createState() => _GenerateReportState();
}

class _GenerateReportState extends State<GenerateReportsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormBuilderState>();
  final DateFormat dtFormatter = DateFormat('dd-MM-yyyy');
  bool isNotVaccinatedSelected = false;
  List<VaccineDrive> completedDrives = [];
  bool isDriveFilterSelected = false;
  bool isDtRangeFilterSelected = false;



  @override
  Widget build(BuildContext context) {
    VaccineDriveBackendAccessor().getCompletedDrives().then((value) => {completedDrives = value});
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.pink.shade50,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      'Generate Reports',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.pink,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                                child: Text(
                                  textAlign: TextAlign.left,
                                  'Select Filters',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.pink,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                                child: FormBuilderRadioGroup<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Is Vaccinated',
                                  ),
                                  initialValue: null,
                                  name: 'isVaccinated',
                                  onChanged: (value) {
                                    if(!isNotVaccinatedSelected && value == 'No') {
                                    setState(() {

                                        isNotVaccinatedSelected = true;
                                        _formKey.currentState?.reset();
                                        _formKey.currentState
                                            ?.fields['isVaccinated']?.didChange(
                                            'No');

                                    }
                                    );
                                    } else if(isNotVaccinatedSelected && value == 'Yes') {
                                      setState(() {
                                        isNotVaccinatedSelected = false;
                                                                             }
                                      );
                                    }
                                  },

                                  options:
                                  ['Yes', 'No', ]
                                      .map((choice) => FormBuilderFieldOption(
                                    value: choice,
                                    child: Text(choice),
                                  ))
                                      .toList(growable: false),
                                  controlAffinity: ControlAffinity.trailing,
                                ),
                              ),
                              Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                                child: FormBuilderDropdown<String>(
                                  name: 'vaccineName',
                                  enabled: !(isNotVaccinatedSelected),
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

                              Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                                child: FormBuilderDateRangePicker(
                                  name: 'date_range',
                                  enabled: !(isNotVaccinatedSelected) && !(isDriveFilterSelected),
                                  firstDate: DateTime(1970),
                                  lastDate: DateTime(2030),
                                  format: dtFormatter,
                                  onChanged: (date) {
                                    if(!isDriveFilterSelected && date != null) {
                                      setState(() {
                                        isDriveFilterSelected = false;
                                        isDtRangeFilterSelected = true;
                                        _formKey.currentState
                                            ?.fields['driveId']?.didChange(
                                            null);

                                      }
                                      );
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Date Range',
                                    helperText: 'Select from and to date',
                                    hintText: 'Select from and to date',
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        _formKey.currentState!.fields['date_range']
                                            ?.didChange(null);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                                child: FutureBuilder<List<VaccineDrive>>(
                                    future: VaccineDriveBackendAccessor().getCompletedDrives(),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.waiting:
                                          return Center(
                                            child: Container(
                                                width: MediaQuery.of(context).size.width * 0.9,

                                                child: LinearProgressIndicator()),
                                          );
                                        default:
                                          if (snapshot.hasError || !snapshot.hasData) {
                                            return FormBuilderDropdown<String>(
                                              name: 'driveId',
                                              enabled: !(isNotVaccinatedSelected) && !(isDtRangeFilterSelected),
                                              decoration: InputDecoration(
                                                labelText: 'By School Drive',
                                                hintText: 'Select Drive',
                                              ),
                                              items: [],

                                            );
                                          } else {
                                            completedDrives = snapshot.data!;
                                            return FormBuilderDropdown<String>(
                                              name: 'driveId',
                                              enabled: !(isNotVaccinatedSelected) && !(isDtRangeFilterSelected),
                                              decoration: InputDecoration(
                                                labelText: 'By School Drive',
                                                hintText: 'Select Drive',
                                              ),
                                              items: completedDrives
                                                  .map((drive) => DropdownMenuItem(
                                                alignment:
                                                AlignmentDirectional.center,
                                                value: drive.uuid,
                                                child: Text(drive.driveName),
                                              ))
                                                  .toList(),
                                              onChanged: (value) {
                                                if(!isDriveFilterSelected && value != null) {
                                                  setState(() {
                                                    isDriveFilterSelected = true;
                                                    isDtRangeFilterSelected = false;
                                                    _formKey.currentState
                                                        ?.fields['date_range']?.didChange(
                                                        null);

                                                  }
                                                  );
                                                }
                                              },
                                            );
                                          }
                                      }
                                    }),

                              ),



                            ],
                          ),
                          //
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 8, 0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink.shade50,
                                    ),
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    _formKey.currentState!.save();
                                    debugPrint(
                                        _formKey.currentState?.value.toString());
                                    routeToFilteredResult();
                                  } else {
                                    debugPrint('validation failed');
                                  }
                                },
                                child: const Text(
                                  'Get Report',
                                  style: TextStyle(color: Colors.pink),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(8, 16, 8, 0),
                              child: OutlinedButton(
                                onPressed: () {
                                  _formKey.currentState
                                      ?.fields['isVaccinated']?.didChange(
                                      null);
                                  _formKey.currentState?.reset();
                                  setState(() {
                                    isDriveFilterSelected = false;
                                    isDtRangeFilterSelected = false;
                                    isNotVaccinatedSelected = false;
                                  });
                                },
                                // color: Theme.of(context).colorScheme.secondary,
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                      color:
                                      Colors.pink),
                                ),
                              ),
                            ),

                          ],
                        ),
                        Row(
                          children: <Widget>[

                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 8, 0),
                              child: Text(
                                'Export Report as ->',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.pink,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(2, 16, 2, 0),
                              child: IconButton(

                                icon: Image.asset('assets/excelicon.png'),

                                color: Colors.grey,
                                iconSize: 20,

                                onPressed: ()  {

                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(2, 16, 2, 0),
                              child: IconButton(

                                icon: Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.pink,
                                  size: 20,
                                ),
                                onPressed: ()  {

                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(2, 16, 2, 0),
                              child: IconButton(

                                icon: Image.asset('assets/csv.png'),

                                color: Colors.pink,
                                iconSize: 20,

                                onPressed: ()  {

                                },
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

  void routeToFilteredResult() {
    var searchForm = _formKey.currentState?.value;
    debugPrint(_formKey.currentState?.value['driveId']);
    debugPrint(_formKey.currentState?.value['isVaccinated']);
    debugPrint(_formKey.currentState?.value['vaccineName']);

    var dtRange = _formKey.currentState?.value['date_range'];

    SearchFilter serchFilter = SearchFilter(vaccineName: _formKey.currentState?.value['vaccineName'],
    driveId: _formKey.currentState?.value['driveId'],
    isVaccinated: _formKey.currentState?.value['isVaccinated']);

    if(dtRange != null) {
      serchFilter.startDt = dtRange.start;
      serchFilter.endDt = dtRange.end;
    }

        Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => StudentSearchWidget(searchFilter: serchFilter,)),
    );
  }
  VaccineDriveBackendAccessor backendAccessor = VaccineDriveBackendAccessor();

  Future<List<VaccineDrive>> getNextDriveDetails() async {
    return await backendAccessor.getNextDrive();
  }

  Future<List<VaccineDrive>> getDrivesToApprove() async {
    return await backendAccessor.getDrivesToApprove();
  }

  Future<int> noOfUpcomingDrives() async {
    return await backendAccessor.countUpcomingDrives();
  }

  Future<List<VaccineDrive>> getUpcomingDrives() async {
    return await backendAccessor.getUpcomingDrives();
  }
}
