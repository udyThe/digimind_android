class LeaveRequest {
  final String? id;
  final int employeeId;
  final String employeeName;
  final String startDate;
  final String endDate;
  final String reason;

  LeaveRequest({
    this.id,
    required this.employeeId,
    required this.employeeName,
    required this.startDate,
    required this.endDate,
    required this.reason,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      employeeId: json['employeeId'] ?? 0,
      employeeName: json['employeeName'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      reason: json['reason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
    };
  }
}
