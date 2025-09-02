import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_provider.dart';
import '../data/models/employee.dart';
import 'leave_request_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<EmployeeProvider>(context, listen: false).loadEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AddOrEditEmployeeDialog(),
              );
            },
          )
        ],
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, child) {
          if (provider.employees.isEmpty) {
            return const Center(child: Text('No employees found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.employees.length,
            itemBuilder: (context, index) {
              final emp = provider.employees[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(emp.name[0]),
                  ),
                  title: Text(emp.name),
                  subtitle: Text('${emp.role} • ${emp.department}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LeaveRequestScreen(employeeName: emp.name),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AddOrEditEmployeeDialog(employee: emp),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          if (emp.id != null) {
                            await Provider.of<EmployeeProvider>(context, listen: false)
                                .deleteEmployee(emp.id!);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}




class AddOrEditEmployeeDialog extends StatefulWidget {
  final Employee? employee;

  const AddOrEditEmployeeDialog({super.key, this.employee});

  @override
  State<AddOrEditEmployeeDialog> createState() => _AddOrEditEmployeeDialogState();
}

class _AddOrEditEmployeeDialogState extends State<AddOrEditEmployeeDialog> {
  final nameController = TextEditingController();
  final deptController = TextEditingController();
  final roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      nameController.text = widget.employee!.name;
      deptController.text = widget.employee!.department;
      roleController.text = widget.employee!.role;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.employee != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Employee' : 'Add Employee'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: deptController,
              decoration: const InputDecoration(labelText: 'Department'),
            ),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          child: Text(isEditing ? 'Update' : 'Add'),
          onPressed: () async {
            final newEmp = Employee(
              id: widget.employee?.id,
              name: nameController.text,
              department: deptController.text,
              role: roleController.text,
              photoUrl: '',
            );

            final provider = Provider.of<EmployeeProvider>(context, listen: false);

            if (isEditing && newEmp.id != null) {
              await provider.updateEmployee(newEmp.id!, newEmp);
            } else {
              await provider.addEmployee(newEmp);
            }

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
