import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:searchable_listview/resources/arrays.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:vaccination_mgmt/accessor/parse_server/student_accessor.dart';
import 'package:vaccination_mgmt/model/search_model.dart';
import 'package:vaccination_mgmt/model/studentDetails.dart';
import 'package:vaccination_mgmt/ui/student_edit.dart';

class StudentSearchWidget extends StatefulWidget {
  SearchFilter? searchFilter;
  StudentSearchWidget({Key? key, this.searchFilter}) : super(key: key);

  @override
  State<StudentSearchWidget> createState() => _StudentSearchState(searchFilter);
}

class _StudentSearchState extends State<StudentSearchWidget> {
  SearchFilter? _searchFilter;
  List<StudentDetails> allStudents = [];
  List<StudentDetails> recent = [];
  _StudentSearchState(this._searchFilter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 12, 0, 0),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SearchableList<StudentDetails>(
                    style: const TextStyle(fontSize: 25),
                    onPaginate: () async {
                      await Future.delayed(const Duration(milliseconds: 100));
                      debugPrint('on pagination');
                      setState(() {
                        recent
                            .cast()
                            .addAll(allStudents.sublist(recent.length));
                      });
                    },
                    builder: (StudentDetails student) =>
                        StudentItem(student: student),
                    loadingWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 20,
                        ),
                        Text('Loading students...')
                      ],
                    ),
                    errorWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text('Error while fetching students')
                      ],
                    ),
                    asyncListCallback: () async {
                      List<StudentDetails> students =
                          await StudentBackendAccessor().getAllStudents(_searchFilter);
                      allStudents = students;
                      int minCut = min(allStudents.length, 6);
                      recent = allStudents.sublist(0, minCut);
                      return recent;
                    },
                    asyncListFilter: (q, list) {
                      if (q.isEmpty) {
                        return recent;
                      }
                      return allStudents
                          .where((element) =>
                              element.name.contains(q) ||
                              element.id.contains(q))
                          .toList();
                    },
                    emptyWidget: const EmptyView(),
                    onRefresh: () async {
                      debugPrint("refreshed");
                    },
                    onItemSelected: (StudentDetails item) {Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditStudentWidget(edit_details: item

                          )),
                    ).then((_) {
                      setState(() {
                        // Call setState to refresh the page.
                      });
                    });},
                    inputDecoration: InputDecoration(
                      labelText: "Search Student By Name or Id",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentItem extends StatelessWidget {
  final StudentDetails student;

  const StudentItem({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            if (student.isVaccinated) ...[
              Icon(
                Icons.check,
                color: Colors.green,
              ),
            ] else ...[
              Icon(
                Icons.warning_amber,
                color: Colors.red,
              ),
            ],
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Id: ${student.id}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Name: ${student.name}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  student.prettyPrintDoseDetails(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('No Student with this name or id'),
      ],
    );
  }
}
