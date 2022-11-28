class Course {
  final String id;
  final String courseInstructor;
  final String courseCredits;
  final String courseID;
  final String courseName;

  Course._(this.id, this.courseInstructor, this.courseCredits, this.courseID,
      this.courseName);

  factory Course.fromJson(Map json) {
    final id = json['id'].replaceAll('ObjectId(\"', '').replaceAll('\")', '');
    final courseInstructor = json['courseInstructor'];
    final courseCredits = json['courseCredits'];
    final courseID = json['courseID'];
    final courseName = json['courseName'];

    return Course._(id, courseInstructor, courseCredits, courseID, courseName);
  }
}
