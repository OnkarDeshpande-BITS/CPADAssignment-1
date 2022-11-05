import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:vaccination_mgmt/model/vaccineDrive.dart';
import 'package:vaccination_mgmt/accessor/parse_server/vaccine_drive_accessor.dart';

class CreateNewDriveWidget extends StatefulWidget {
  const CreateNewDriveWidget({Key? key}) : super(key: key);

  @override
  CreateNewDriveState createState() => CreateNewDriveState();
}

class CreateNewDriveState extends State<CreateNewDriveWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormBuilderState>();

  void saveDriveDetails() async {
    var driveForm = _formKey.currentState?.value;
    debugPrint(_formKey.currentState?.value['driveName']);
    debugPrint(_formKey.currentState?.value['driveDate'].toString());

    VaccineDrive drive =
        VaccineDrive(driveForm?['driveName'], driveForm?['driveDate']);
    drive.isPreApproved = driveForm?['isPreApproved'];
    if (driveForm?['covaxineDoses'] != null) {
      drive.addVaccineDetails(
          vaccineName: 'Covaxine',
          doses: int.parse(driveForm?['covaxineDoses']));
    }
    if (driveForm?['covishieldDoses'] != null) {
      drive.addVaccineDetails(
          vaccineName: 'Covishield',
          doses: int.parse(driveForm?['covishieldDoses']));
    }
    VaccineDriveBackendAccessor().createVaccineDrive(drive);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Drive Successfully Created"),
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
                        'Conduct New Drive',
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
                                decoration: InputDecoration(
                                  labelText: 'Drive Name',
                                ),

                                // valueTransformer: (text) => num.tryParse(text),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter value for DriveName";
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
                              child: FormBuilderDateTimePicker(
                                name: 'driveDate',
                                initialEntryMode: DatePickerEntryMode.calendar,
                                initialValue: DateTime.now(),
                                inputType: InputType.date,
                                decoration: InputDecoration(
                                  labelText: 'Drive Date',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _formKey.currentState!.fields['date']
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
                                name: 'isPreApproved',
                                initialValue: false,
                                title: Text(
                                  'Drive Is PreApproved',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                              child: FormBuilderTextField(
                                name: 'covaxineDoses',
                                decoration: InputDecoration(
                                  labelText: 'Covaxin Doses',
                                ),

                                // valueTransformer: (text) => num.tryParse(text),

                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                              child: FormBuilderTextField(
                                name: 'covishieldDoses',
                                decoration: InputDecoration(
                                  labelText: 'Covishield Doses',
                                ),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
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
                                  saveDriveDetails();
                                } else {
                                  debugPrint('validation failed');
                                }
                              },
                              child: const Text(
                                'Submit',
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
        )

      ),
    );
  }
}
