import 'package:flutter/material.dart';
import 'package:vaccination_mgmt/model/vaccineDrive.dart';
import 'package:vaccination_mgmt/ui/templates/action_row.dart';
import 'package:vaccination_mgmt/ui/new_drive.dart';
import 'package:vaccination_mgmt/accessor/parse_server/vaccine_drive_accessor.dart';
import 'package:intl/intl.dart';
import 'package:vaccination_mgmt/ui/drive_list_view.dart';
import 'package:vaccination_mgmt/ui/drive_edit.dart';

class ManageDriveWidget extends StatefulWidget {
  const ManageDriveWidget({Key? key}) : super(key: key);

  @override
  _ManageDriveStateState createState() => _ManageDriveStateState();
}

class _ManageDriveStateState extends State<ManageDriveWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final DateFormat dtFormatter = DateFormat('dd-MM-yyyy');

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
              color: Colors.blueAccent,
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 40, 20, 0),
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
                          'assets/manageVaccine.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Manage Drive',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
            child: CustomActionRow('Conduct New', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateNewDriveWidget()),
              ).then((_) {
                setState(() {
                  // Call setState to refresh the page.
                });
              });
            }),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: CustomActionRow(
                'View/Modify Drive', () => debugPrint("View drive clicked")),
          ),
          Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: FutureBuilder<List<VaccineDrive>>(
                  future: getNextDriveDetails(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 60,
                              child: CircularProgressIndicator()),
                        );
                      default:
                        VaccineDrive drive;
                        var nextDriveDt;

                        if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return CustomActionRow(
                              'Manage/Modify Next Drive - No Next Drive',
                              () => debugPrint("Next drive clicked"));
                        } else {
                          drive = snapshot.data![0];
                          nextDriveDt = drive!.driveDt;

                          return CustomActionRow(
                              'Manage/Modify Next Drive on ${dtFormatter.format(nextDriveDt)}',
                              () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditDriveWidget(
                                                editPageTitle:
                                                    'Edit Next Drive',
                                                drive: drive,
                                                forApproval: false,
                                              )),
                                    )
                                  });
                        }
                    }
                  })),
          Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: FutureBuilder<List<VaccineDrive>>(
                  future: getDrivesToApprove(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 60,
                              child: CircularProgressIndicator()),
                        );
                      default:
                        if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data!.length == 0) {
                          return CustomActionRow(
                              'Approve Drives - 0 Pending Approvals', () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("There are no Drives for Approval"),
                              duration: Duration(seconds: 2),
                            ));
                          });
                        } else {
                          int noOfDrivesForApproval = snapshot.data!.length;
                          return CustomActionRow(
                              'Approve Drives - ${noOfDrivesForApproval} Require Approvals',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DriveListWidget(
                                        title: 'Need Approval',
                                        listGetter: () => getDrivesToApprove(),
                                        itemEditCall: (driveToEdit, pageRefreshFunction) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditDriveWidget(
                                                      editPageTitle:
                                                          'Approve & Edit Drive',
                                                      drive: driveToEdit,
                                                      forApproval: true,
                                                    )),
                                          ).then((_) {
                                            pageRefreshFunction();
                                          });
                                        },
                                      )),
                            ).then((_) {
                              setState(() {
                                // Call setState to refresh the page.
                              });
                            });
                          });
                        }
                    }
                  })),
          Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: FutureBuilder<int>(
                  future: noOfUpcomingDrives(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 60,
                              child: CircularProgressIndicator()),
                        );
                      default:
                        if (snapshot.hasError || !snapshot.hasData) {
                          return CustomActionRow('0 Upcoming Drives', () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("No Upcoming Drives"),
                              duration: Duration(seconds: 2),
                            ));
                          });
                        } else {
                          int noOfUpcoming = snapshot.data!;
                          return CustomActionRow(
                              '${noOfUpcoming} Upcoming Drives', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DriveListWidget(
                                      title: 'Upcoming Drives',
                                      listGetter: () => getUpcomingDrives(),
                                      itemEditCall:
                                          (driveToEdit, pageRefreshFunction) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditDriveWidget(
                                                    editPageTitle: 'Edit Drive',
                                                    drive: driveToEdit,
                                                    forApproval: false,
                                                  )),
                                        ).then((_) {
                                          pageRefreshFunction();
                                        });
                                      })),
                            );
                          });
                        }
                    }
                  })),
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
