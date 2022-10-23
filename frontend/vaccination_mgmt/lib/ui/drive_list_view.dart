import 'package:flutter/material.dart';
import 'package:vaccination_mgmt/model/vaccineDrive.dart';
import 'package:vaccination_mgmt/ui/templates/action_row.dart';
import 'package:vaccination_mgmt/ui/new_drive.dart';
import 'package:vaccination_mgmt/accessor/parse_server/vaccine_drive_accessor.dart';
import 'package:intl/intl.dart';

class DriveListWidget extends StatefulWidget {
  final String title;
  final Function listGetter;
  final Function itemEditCall;

  const DriveListWidget(
      {super.key,
      required this.title,
      required this.listGetter,
      required this.itemEditCall});

  @override
  _DriveListWidget createState() =>
      _DriveListWidget(title, listGetter, itemEditCall);
}

class _DriveListWidget extends State<DriveListWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final DateFormat dtFormatter = DateFormat('dd-MM-yyyy');
  final String listTitle;
  final Function listGetter;
  final Function itemEditCall;

  _DriveListWidget(this.listTitle, this.listGetter, this.itemEditCall);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white54,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                          Text(listTitle,
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
          Expanded(
              child: FutureBuilder<List<VaccineDrive>>(
                  future: listGetter(),
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
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error. Please Try After Sometime"),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("No Data..."),
                          );
                        } else {
                          return ListView.builder(
                              padding: EdgeInsets.only(top: 10.0),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                VaccineDrive drive = snapshot.data![index];

                                final driveName = drive.driveName;
                                final driveDt = drive.driveDt;
                                final totalDoses = drive.totalDoses;

                                return ListTile(
                                  title: CustomActionRow(
                                      '$driveName on ${dtFormatter.format(driveDt)} having $totalDoses Doses',
                                      () => itemEditCall(drive, () {
                                            setState(() {
                                              // Call setState to refresh the page.
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
}
