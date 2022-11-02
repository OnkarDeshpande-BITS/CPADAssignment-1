import 'package:flutter/material.dart';
import 'package:vaccination_mgmt/model/vaccineDrive.dart';
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

class ManageStudentWidget extends StatefulWidget {
  const ManageStudentWidget({Key? key}) : super(key: key);

  @override
  _ManageStudentState createState() => _ManageStudentState();
}

class _ManageStudentState extends State<ManageStudentWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final DateFormat dtFormatter = DateFormat('dd-MM-yyyy');
  PlatformFile? studentBulkfile;
  String? uploadFileName;
  bool fileChoosen = false;

  Future getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    print(result?.files.single.name);

    if (result != null) {
      PlatformFile file = result.files.single;

      setState(() {
        studentBulkfile = file;
        uploadFileName = file.name;
        fileChoosen = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Unable to pick file for uploading"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future bulkUploadStudentData() async {
    await StudentFileUploader().uploadStudentDetails(studentBulkfile!, kIsWeb);
    setState(() {
      studentBulkfile = null;
      uploadFileName = null;
      fileChoosen = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Successfully uploaded student data"),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white54,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(42, 40, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/studentVaccine-1.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(14, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Manage Students',
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                fontFamily: 'Lexend Deca',
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
            child: CustomActionRow('Add New', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddNewStudentWidget()),
              ).then((_) {
                setState(() {
                  // Call setState to refresh the page.
                });
              });
            }),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: CustomActionRow('View/Modify Student Data',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentSearchWidget()),
                )),
          ),

          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,

                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.black54,
                        width: 0,
                      ),
                    ),
                    child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Bulk Load Student Data',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.blueGrey,
                                    primary: Colors.white,
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: getFile,
                                ),
                              ],
                            ),
                          ),
                          if (fileChoosen) ...[
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16, 2, 4, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 2, 0),
                                    child: Text(
                                      'Selected File : ${uploadFileName}',
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF57636C),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                                    child: OutlinedButton(
                                      onPressed: bulkUploadStudentData,
                                      // color: Theme.of(context).colorScheme.secondary,
                                      child: Text(
                                        'Upload',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                            color:
                                            Theme.of(context).colorScheme.secondary),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ])),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
