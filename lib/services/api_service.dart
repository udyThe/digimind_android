import 'package:dio/dio.dart';
import '../data/models/employee.dart';
import '../data/models/leave_request.dart';

class ApiService {
  final Dio dio = Dio();
  final String baseUrl =
      'https://crudcrud.com/api/b6ac6a892dee4b1cbd43beb818d1df29/employees';

  final String leaveUrl =
      'https://crudcrud.com/api/b6ac6a892dee4b1cbd43beb818d1df29/leave-requests';

  // ✅ Employee APIs
  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await dio.get(baseUrl);
      return (response.data as List)
          .map((json) => Employee.fromJson(json))
          .toList();
    } catch (e) {
      print("Fetch error: $e");
      rethrow;
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      await dio.post(baseUrl, data: employee.toJson());
    } catch (e) {
      print("Add error: $e");
      rethrow;
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      await dio.delete('$baseUrl/$id');
    } catch (e) {
      print("Delete error: $e");
      rethrow;
    }
  }

  Future<void> updateEmployee(String id, Employee employee) async {
    try {
      await dio.put('$baseUrl/$id', data: employee.toJson());
    } catch (e) {
      print("Update error: $e");
      rethrow;
    }
  }

  // ✅ Leave Request APIs
  Future<void> submitLeaveRequest(LeaveRequest request) async {
    try {
      await dio.post(leaveUrl, data: request.toJson());
    } catch (e) {
      print("Submit Leave error: $e");
      rethrow;
    }
  }

  Future<List<LeaveRequest>> fetchLeaveRequests(String employeeName) async {
    try {
      final response = await dio.get(leaveUrl);
      return (response.data as List)
          .map((json) => LeaveRequest.fromJson(json))
          .where((lr) => lr.employeeName == employeeName)
          .toList();
    } catch (e) {
      print("Fetch Leave error: $e");
      rethrow;
    }
  }
}
