class Employee {
  final String? id;
  final String name;
  final String department;
  final String role;
  final String photoUrl;

  Employee({
    this.id,
    required this.name,
    required this.department,
    required this.role,
    required this.photoUrl,
  });

  // ✅ Needed for converting from Firebase/CRUD response
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'] ?? json['id'], // support both Firebase and CRUDCRUD
      name: json['name'] ?? '',
      department: json['department'] ?? '',
      role: json['role'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
    );
  }

  // ✅ Needed for writing to Firebase/CRUD
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'department': department,
      'role': role,
      'photoUrl': photoUrl,
    };
  }
}
