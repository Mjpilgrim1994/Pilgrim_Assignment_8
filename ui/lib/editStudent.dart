import 'package:flutter/material.dart';
import 'api.dart';
import 'main.dart';
import 'editCourse.dart';

class EditStudent extends StatefulWidget {
  final String id, fname, lname, studentID;

  final CourseApi api = CourseApi();

  EditStudent(this.id, this.fname, this.lname, this.studentID, {super.key});

  @override
  State<EditStudent> createState() =>
      _EditStudentState(id, fname, lname, studentID);
}

class _EditStudentState extends State<EditStudent> {
  final String id, fname, lname, studentID;

  _EditStudentState(this.id, this.fname, this.lname, this.studentID);

  void _changeStudentName(id, fname) {
    setState(() {
      widget.api.editName(id, fname);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }

  TextEditingController fnameControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student Name'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(5),
              child: Column(children: <Widget>[
                Text("Edit student's first name"),
                TextFormField(controller: fnameControl),
                ElevatedButton(
                    onPressed: () => {
                          _changeStudentName(widget.id, fnameControl.text),
                        },
                    child: Text("Change Name"))
              ]))
        ]),
      ),
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
