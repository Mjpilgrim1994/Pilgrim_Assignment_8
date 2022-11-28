import 'package:flutter/material.dart';
import 'api.dart';
import 'editCourse.dart';
import 'editStudent.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilgrim Assignment 8',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final CourseApi api = CourseApi();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List courses = [];
  bool _dbLoaded = false;

  void initState() {
    super.initState();
    widget.api.findAllCourses().then((data) {
      setState(() {
        courses = data;
        _dbLoaded = true;
      });
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
                    const Text(
                      'Courses',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                    Container(padding: const EdgeInsets.all(5)),
                    const Text('Class ID  |  Class Name  |  Credits',
                        style: TextStyle(fontSize: 18, letterSpacing: 2)),
                    Expanded(
                      child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(15.0),
                          children: [
                            ...courses
                                .map<Widget>((course) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30),
                                    child: TextButton(
                                        onPressed: () => {
                                              Navigator.pop(context),
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => EditCourse(
                                                          course['_id'],
                                                          course[
                                                              'courseInstructor'],
                                                          course[
                                                              'courseCredits'],
                                                          course['courseID'],
                                                          course[
                                                              'courseName']))),
                                            },
                                        child: ListTile(
                                            leading: CircleAvatar(
                                              radius: 30,
                                              child: Text(course['courseID'],
                                                  style: const TextStyle(
                                                      fontSize: 10)),
                                            ),
                                            title: Text(
                                              (course['courseName'] +
                                                  "  -  " +
                                                  course['courseCredits']),
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            )))))
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
    );
  }
}
