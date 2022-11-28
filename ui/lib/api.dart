import 'package:dio/dio.dart';
import './models/students.dart';
import './models/courses.dart';

const String localhost = 'http://10.0.2.2:1200/';

class CourseApi {
  final _dio = Dio(BaseOptions(baseUrl: localhost));

  Future<List> findAllCourses() async {
    final response = await _dio.get('/findAllCourses');

    return response.data['course'];
  }

  Future<List> findAllStudents() async {
    final response = await _dio.get('/findAllStudents');

    return response.data['student'];
  }

  Future<List> editName(String id, String fname) async {
    final response =
        await _dio.post('/updateStudentById', data: {'id': id, 'fname': fname});
    return response.data;
  }

  Future deleteCourse(String id) async {
    final response = await _dio.post('/deleteCourseById', data: {'id': id});
  }
}
