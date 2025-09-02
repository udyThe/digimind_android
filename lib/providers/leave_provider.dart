import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/models/leave_request.dart';

class LeaveProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'leave_requests';

  List<LeaveRequest> _requests = [];
  List<LeaveRequest> get requests => _requests;

  Future<void> submitLeaveRequest(LeaveRequest request) async {
    try {
      await _firestore.collection(_collection).add(request.toJson());
      await fetchLeaveRequests(request.employeeName); // refresh
    } catch (e) {
      print('Submit Leave Error: $e');
    }
  }

  Future<void> fetchLeaveRequests(String employeeName) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('employeeName', isEqualTo: employeeName)
          .get();

      _requests = snapshot.docs.map((doc) {
        final data = doc.data();
        return LeaveRequest(
          id: doc.id,
          employeeId: data['employeeId'] ?? 0,
          employeeName: data['employeeName'] ?? '',
          startDate: data['startDate'] ?? '',
          endDate: data['endDate'] ?? '',
          reason: data['reason'] ?? '',
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Fetch Leave Error: $e');
    }
  }
}
