import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/models/employee.dart';

class EmployeeProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'employees';

  List<Employee> _employees = [];
  List<Employee> get employees => _employees;

  Future<void> loadEmployees() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      _employees = snapshot.docs.map((doc) {
        return Employee(
          id: doc.id,
          name: doc['name'],
          department: doc['department'],
          role: doc['role'],
          photoUrl: doc['photoUrl'] ?? '',
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading employees: $e');
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      await _firestore.collection(_collection).add(employee.toJson());
      await loadEmployees(); // refresh
    } catch (e) {
      print('Error adding employee: $e');
    }
  }

  Future<void> updateEmployee(String id, Employee employee) async {
    try {
      await _firestore.collection(_collection).doc(id).update(employee.toJson());
      await loadEmployees();
    } catch (e) {
      print('Error updating employee: $e');
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      await loadEmployees();
    } catch (e) {
      print('Error deleting employee: $e');
    }
  }
}
