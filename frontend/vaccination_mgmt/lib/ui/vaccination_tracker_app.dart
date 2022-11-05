import 'package:flutter/material.dart';
import 'package:vaccination_mgmt/ui/dashboard.dart';
import 'package:vaccination_mgmt/ui/generate_reports.dart';
import 'package:vaccination_mgmt/ui/manage_drive.dart';
import 'package:vaccination_mgmt/ui/manage_student.dart';
import 'package:vaccination_mgmt/ui/student_search.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class VaccinationTrackerApp extends StatefulWidget {
  const VaccinationTrackerApp({Key? key}) : super(key: key);

  @override
  _VaccinationTrackerState createState() => _VaccinationTrackerState();
}

class MenuItem {
  final IconData iconData;
  final String text;

  const MenuItem(this.iconData, this.text);
}

class _VaccinationTrackerState extends State<VaccinationTrackerApp> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final menuItemList = const <MenuItem>[
    MenuItem(Icons.home, 'Home'),
    MenuItem(Icons.accessibility, 'Students'),
    MenuItem(Icons.vaccines, 'Drive'),
    MenuItem(Icons.analytics, 'Reports'),
  ];
  int _currentIndex = 0;
  final _buildBody = const <Widget>[DashboardWidget(), ManageStudentWidget(), ManageDriveWidget(), GenerateReportsWidget()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: _onItemTapped,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.amber,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.people),
            title: Text('Students'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.vaccines),
            title: Text(
              'Drive',
            ),
            activeColor: Colors.blue,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.analytics),
            title: Text('Reports'),
            activeColor: Colors.pink,
            textAlign: TextAlign.center,
          ),
        ],
      ),

    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
