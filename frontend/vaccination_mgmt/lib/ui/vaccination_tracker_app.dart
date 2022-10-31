import 'package:flutter/material.dart';
import 'package:vaccination_mgmt/ui/dashboard.dart';
import 'package:vaccination_mgmt/ui/manage_drive.dart';
import 'package:vaccination_mgmt/ui/manage_student.dart';

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
  ];
  int _selectedIndex = 0;
  final _buildBody = const <Widget>[DashboardWidget(), ManageStudentWidget(), ManageDriveWidget()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: menuItemList
            .map((MenuItem menuItem) => BottomNavigationBarItem(
                  icon: Icon(menuItem.iconData),
                  label: menuItem.text,
                ))
            .toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
