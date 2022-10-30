import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vaccination_mgmt/accessor/parse_server/vaccine_drive_accessor.dart';
import 'package:vaccination_mgmt/model/vaccineDrive.dart';
import 'package:intl/intl.dart';
import 'package:vaccination_mgmt/accessor/parse_server/student_accessor.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final DateFormat dtFormatter = DateFormat('dd-MM-yyyy');
  final NumberFormat numFormat = NumberFormat("##00");

  @override
  Widget build(BuildContext context) {
    Map<String, String> vaccineTrackerMap = {
      'totalStudents': '0',
      'totalVaccinated': '0',
      'ratio': '0'
    };
    Map<String, String> stats = {

    };
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: Color(0xFFF1F4F8),
        automaticallyImplyLeading: false,
        title: Text(
          'Welcome <LoggedIn User>',
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Color(0xFF0F1113),
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'School Vaccination Program Overview',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Color(0xFF57636C),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 0,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  runAlignment: WrapAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 12),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 190,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x34090F13),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                              child: FutureBuilder<Map<String, String>>(
                                  future: getVaccinationTracker(),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                        return Center(
                                          child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              height: 1,
                                              child: LinearProgressIndicator()),
                                        );
                                      default:
                                        if (snapshot.hasError ||
                                            !snapshot.hasData) {
                                          vaccineTrackerMap = vaccineTrackerMap;
                                        } else {
                                          vaccineTrackerMap = snapshot.data!;
                                        }
                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 12, 0, 0),
                                              child: Text(
                                                'Vaccination Tracker',
                                                style: TextStyle(
                                                  fontFamily: 'Outfit',
                                                  color: Color(0xFF0F1113),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 10, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 10, 0, 0),
                                                    child: Text(
                                                      'Total Students',
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 200, 0),
                                                    child: Text(
                                                      vaccineTrackerMap[
                                                          'totalStudents']!,
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 4, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 10, 0, 0),
                                                    child: Text(
                                                      'Vaccinated Students',
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 200, 0),
                                                    child: Text(
                                                      vaccineTrackerMap[
                                                          'totalVaccinated']!,
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 0, 0),
                                                    child: Text(
                                                      'Progress',
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 0, 0),
                                                    child: Text(
                                                      '${vaccineTrackerMap['totalVaccinated']}/${vaccineTrackerMap['totalStudents']}',
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 8, 0, 0),
                                                child: LinearPercentIndicator(
                                                  percent: double.parse(
                                                      vaccineTrackerMap[
                                                          'ratio']!),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.38,
                                                  lineHeight: 8,
                                                  animation: true,
                                                  progressColor:
                                                      Color(0xFF4B39EF),
                                                  backgroundColor:
                                                      Color(0xFFE0E3E7),
                                                  barRadius: Radius.circular(8),
                                                  padding: EdgeInsets.zero,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                    }
                                  }),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 12),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x34090F13),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Completed Drives',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF0F1113),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 16, 0, 16),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FutureBuilder<int>(
                                            future: noOfCompletedDrives(),
                                            builder: (context, snapshot) {
                                              String noOfCompletedDrives = '00';
                                              switch (
                                                  snapshot.connectionState) {
                                                case ConnectionState.none:
                                                case ConnectionState.waiting:
                                                  return Center(
                                                    child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        height: 60,
                                                        child:
                                                            CircularProgressIndicator()),
                                                  );
                                                default:
                                                  if (snapshot.hasError) {
                                                    noOfCompletedDrives = 'XX';
                                                  } else if (!snapshot
                                                      .hasData) {
                                                    noOfCompletedDrives = '00';
                                                  } else {
                                                    noOfCompletedDrives =
                                                        numFormat.format(
                                                            snapshot.data!);
                                                  }
                                                  return Text(
                                                    noOfCompletedDrives,
                                                    style: TextStyle(
                                                      fontFamily: 'Outfit',
                                                      color: Color(0xFF0F1113),
                                                      fontSize: 82,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  );
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Last Drive Date',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  FutureBuilder<List<VaccineDrive>>(
                                      future: getLastCompletedDriveDetails(),
                                      builder: (context, snapshot) {
                                        String nextDriveDt = '--';
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                            return Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              height: 1,
                                              child: LinearProgressIndicator(),
                                            );
                                          default:
                                            if (snapshot.hasError ||
                                                !snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              nextDriveDt = '--';
                                            } else {
                                              nextDriveDt = dtFormatter.format(
                                                  snapshot.data![0].driveDt);
                                            }
                                            return Text(
                                              nextDriveDt,
                                              style: TextStyle(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 12),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x34090F13),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Upcoming Drives',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF0F1113),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 16, 0, 16),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FutureBuilder<int>(
                                            future: noOfUpcomingDrives(),
                                            builder: (context, snapshot) {
                                              String noOfUpcomingDrives = '00';
                                              switch (
                                                  snapshot.connectionState) {
                                                case ConnectionState.none:
                                                case ConnectionState.waiting:
                                                  return Center(
                                                    child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        height: 60,
                                                        child:
                                                            CircularProgressIndicator()),
                                                  );
                                                default:
                                                  if (snapshot.hasError) {
                                                    noOfUpcomingDrives = 'XX';
                                                  } else if (!snapshot
                                                      .hasData) {
                                                    noOfUpcomingDrives = '00';
                                                  } else {
                                                    noOfUpcomingDrives =
                                                        numFormat.format(
                                                            snapshot.data!);
                                                  }
                                                  return Text(
                                                    noOfUpcomingDrives,
                                                    style: TextStyle(
                                                      fontFamily: 'Outfit',
                                                      color: Color(0xFF0F1113),
                                                      fontSize: 82,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  );
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Next Drive On',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  FutureBuilder<List<VaccineDrive>>(
                                      future: getNextDriveDetails(),
                                      builder: (context, snapshot) {
                                        String nextDriveDt = '--';
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                            return Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              height: 1,
                                              child: LinearProgressIndicator(),
                                            );
                                          default:
                                            if (snapshot.hasError ||
                                                !snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              nextDriveDt = '--';
                                            } else {
                                              nextDriveDt = dtFormatter.format(
                                                  snapshot.data![0].driveDt);
                                            }
                                            return Text(
                                              nextDriveDt,
                                              style: TextStyle(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 12),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 190,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x34090F13),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                              child: FutureBuilder<Map<String, String>>(
                                  future: getVaccinationStats(),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                        return Center(
                                          child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              height: 1,
                                              child: LinearProgressIndicator()),
                                        );
                                      default:
                                        if (snapshot.hasError ||
                                            !snapshot.hasData) {
                                          stats = stats;
                                        } else {
                                          stats = snapshot.data!;
                                        }
                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 12, 0, 0),
                                              child: Text(
                                                'Vaccination Stats',
                                                style: TextStyle(
                                                  fontFamily: 'Outfit',
                                                  color: Color(0xFF0F1113),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 4, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 10, 0, 0),
                                                    child: Text(
                                                      '#Vaccinated In School Drive',
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 200, 0),
                                                    child: Text(
                                                      stats['inSchool']!,
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 4, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 0, 0),
                                                    child: Text(
                                                      '#Vaccinated Outside Drive',
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 200, 0),
                                                    child: Text(
                                                      stats['outsideSchool']!,
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 4, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 0, 0),
                                                    child: Text(
                                                      '#Covaxine Doses',
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 200, 0),
                                                    child: Text(
                                                      stats['noCovaxine']!,
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 4, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 0, 0),
                                                    child: Text(
                                                      '#Covishield Doses',
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 200, 0),
                                                    child: Text(
                                                      stats['noCovishiled']!,
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            Color(0xFF57636C),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                    }
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  VaccineDriveBackendAccessor vaccineBackendAccessor =
      VaccineDriveBackendAccessor();
  StudentBackendAccessor studentBackendAccessor = StudentBackendAccessor();

  Future<List<VaccineDrive>> getNextDriveDetails() async {
    return await vaccineBackendAccessor.getNextDrive();
  }

  Future<int> noOfUpcomingDrives() async {
    return await vaccineBackendAccessor.countUpcomingDrives();
  }

  Future<int> noOfCompletedDrives() async {
    return await vaccineBackendAccessor.countCompletedDrives();
  }

  Future<List<VaccineDrive>> getLastCompletedDriveDetails() async {
    return await vaccineBackendAccessor.getLastCompleted();
  }

  Future<Map<String, String>> getVaccinationTracker() async {
    int totalStudents = await studentBackendAccessor.getTotalStudents();
    int totalVaccinated =
        await studentBackendAccessor.getTotalVaccinatedStudents();
    Map<String, String> trackerMap = new Map();
    trackerMap['totalStudents'] = totalStudents.toString();
    trackerMap['totalVaccinated'] = totalVaccinated.toString();
    trackerMap['ratio'] = '0';
    if (totalStudents > 0) {
      trackerMap['ratio'] = (totalVaccinated / totalStudents).toString();
    }
    return trackerMap;
  }

  Future<Map<String, String>> getVaccinationStats() async {
    int totalVaccinated =
        await studentBackendAccessor.getTotalVaccinatedStudents();
    int inSchool = await studentBackendAccessor.getVaccinatedInSchoolCount();
    int noCovaxine =
        await studentBackendAccessor.getCountByVaccine('Covaccine');
    Map<String, String> trackerMap = new Map();
    trackerMap['inSchool'] = inSchool.toString();
    trackerMap['outsideSchool'] = (totalVaccinated - inSchool).toString();
    trackerMap['noCovaxine'] = noCovaxine.toString();
    trackerMap['noCovishiled'] = (totalVaccinated - noCovaxine).toString();
    return trackerMap;
  }
}
