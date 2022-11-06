import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:vaccination_mgmt/model/vaccineDrive.dart';
import 'package:vaccination_mgmt/accessor/parse_server/vaccine_drive_accessor.dart';
import 'package:intl/intl.dart';

class EditDriveWidget extends StatefulWidget {
  final String editPageTitle;
  final VaccineDrive drive;
  final bool? forApproval;

  const EditDriveWidget(
      {super.key,
      required this.editPageTitle,
      required this.drive,
      this.forApproval});

  @override
  EditDriveState createState() =>
      EditDriveState(editPageTitle, drive, forApproval);
}

class EditDriveState extends State<EditDriveWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormBuilderState>();
  final DateFormat dtFormatter = DateFormat('dd-MM-yyyy');
  final String editPageTitle;
  final VaccineDrive drive;
  final bool? forApproval;
  bool isViewOnly = false;

  EditDriveState(this.editPageTitle, this.drive, this.forApproval);

  void updateDriveDetails() async {
    var driveForm = _formKey.currentState?.value;
    debugPrint(_formKey.currentState?.value['driveName']);
    debugPrint(_formKey.currentState?.value['driveDate'].toString());

    VaccineDrive driveClone = VaccineDrive(drive.driveName, drive.driveDt);
    driveClone.uuid = drive.uuid;
    driveClone.state = drive.state;

    if (forApproval == true && driveForm?['approved']) {
      driveClone.state = DriveState.PENDING;
    }

    if (driveForm?['covaxineDoses'] != null) {
      driveClone.addVaccineDetails(
          vaccineName: 'Covaxine',
          doses: int.parse(driveForm?['covaxineDoses']));
    }
    if (driveForm?['covishieldDoses'] != null) {
      driveClone.addVaccineDetails(
          vaccineName: 'Covishield',
          doses: int.parse(driveForm?['covishieldDoses']));
    }
    VaccineDriveBackendAccessor().updateVaccineDrive(driveClone);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Drive Successfully Saved"),
      duration: Duration(seconds: 2),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> vaccineMap = {
      for (var e in drive.vaccineDetails) e.vaccineName: e.noOfDoses.toString()
    };
    isViewOnly = drive.state == DriveState.COMPLETED;
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
                          size: 30,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        editPageTitle,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black54,
                          fontSize: 22,
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
                                name: 'driveName',
                                initialValue: drive.driveName,
                                enabled: false,
                                decoration: const InputDecoration(
                                  labelText: 'Drive Name',
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                              child: FormBuilderTextField(
                                name: 'driveDate',
                                initialValue: dtFormatter.format(drive.driveDt),
                                enabled: !isViewOnly,
                                decoration: const InputDecoration(
                                  labelText: 'Drive Date',
                                ),
                              ),
                            ),
                            if(!isViewOnly) ...[
                              Visibility(
                                  visible: forApproval == true,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16, 16, 16, 0),
                                    child: FormBuilderCheckbox(
                                      name: 'approved',
                                      initialValue: false,
                                      title: Text(
                                        'Approve',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )),
                            ],

                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                              child: FormBuilderTextField(
                                name: 'covaxineDoses',
                                initialValue: vaccineMap.containsKey('Covaxine')
                                    ? vaccineMap['Covaxine']
                                    : '0',
                                decoration: InputDecoration(
                                  labelText: 'Covaxin Doses',
                                ),

                                enabled: !isViewOnly,

                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                              child: FormBuilderTextField(
                                name: 'covishieldDoses',
                                initialValue: vaccineMap.containsKey('Covishield')
                                    ? vaccineMap['Covishield']
                                    : '0',
                                decoration: InputDecoration(
                                  labelText: 'Covishield Doses',
                                ),
                                enabled: !isViewOnly,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ],
                        ),
                        //
                      ),
                      if(!isViewOnly) ...[
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

                    ],
                  ),
                ),
              ),
            ],
          ),
        )

      ),
    );
  }
}
