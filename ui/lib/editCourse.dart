import 'package:flutter/material.dart';
import 'api.dart';
import 'main.dart';
import 'editStudent.dart';

class EditCourse extends StatefulWidget {
  final String id, courseInstructor, courseCredits, courseID, courseName;

  final CourseApi api = CourseApi();

  EditCourse(this.id, this.courseInstructor, this.courseCredits, this.courseID,
      this.courseName,
      {super.key});

  @override
  State<EditCourse> createState() => _EditCourseState(
      id, courseInstructor, courseCredits, courseID, courseName);
}

class _EditCourseState extends State<EditCourse> {
  final String id, courseInstructor, courseCredits, courseID, courseName;
  List students = [];
  bool _dbLoaded = false;

  _EditCourseState(this.id, this.courseInstructor, this.courseCredits,
      this.courseID, this.courseName);

  void initState() {
    super.initState();
    widget.api.findAllStudents().then((data) {
      setState(() {
        students = data;
        _dbLoaded = true;
      });
    });
  }

  void _deleteCourse(id) {
    setState(() {
      widget.api.deleteCourse(id);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilgrim Assignment 8'),
      ),
      body: Center(
          child: _dbLoaded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(padding: const EdgeInsets.all(5)),
                    Text(
                      ("Students of ${widget.courseName}"),
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    Container(padding: const EdgeInsets.all(5)),
                    TextButton(
                        onPressed: () => {
                              _deleteCourse(widget.id),
                            },
                        child: const Text("Delete Course",
                            style: TextStyle(
                                color: Colors.black,
                                backgroundColor: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                    const Text('First Name  |  Last Name  |  ID',
                        style: TextStyle(fontSize: 18, letterSpacing: 2)),
                    Expanded(
                      child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(15.0),
                          children: [
                            ...students
                                .map<Widget>((student) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30),
                                    child: TextButton(
                                        onPressed: () => {
                                              Navigator.pop(context),
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditStudent(
                                                            student['_id'],
                                                            student['fname'],
                                                            student['lname'],
                                                            student[
                                                                'studentID'],
                                                          ))),
                                            },
                                        child: Text(
                                            (student['fname'] +
                                                "  " +
                                                student['lname'] +
                                                "  -  " +
                                                student['studentID']),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black)))))
                                .toList(),
                          ]),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                      Text("Loading In Progress"),
                      CircularProgressIndicator()
                    ])),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.home),
          onPressed: () => {
                Navigator.pop(context),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage())),
              }),
    );
  }
}
