import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/leave_request.dart';
import '../providers/leave_provider.dart';

class LeaveRequestScreen extends StatefulWidget {
  final String employeeName;

  const LeaveRequestScreen({super.key, required this.employeeName});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final reasonController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    setState(() => loading = true);
    try {
      await Provider.of<LeaveProvider>(context, listen: false)
          .fetchLeaveRequests(widget.employeeName);
    } catch (e) {
      print("Error fetching leaves: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> submitRequest() async {
    final newReq = LeaveRequest(
      employeeId: DateTime.now().millisecondsSinceEpoch,
      employeeName: widget.employeeName,
      startDate: startDateController.text,
      endDate: endDateController.text,
      reason: reasonController.text,
    );

    await Provider.of<LeaveProvider>(context, listen: false)
        .submitLeaveRequest(newReq);

    await fetchRequests();
    startDateController.clear();
    endDateController.clear();
    reasonController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final leaveRequests =
        Provider.of<LeaveProvider>(context).requests;

    return Scaffold(
      appBar: AppBar(title: Text('Leave Requests - ${widget.employeeName}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Submit Leave Request',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: startDateController,
              decoration: const InputDecoration(
                labelText: 'Start Date (YYYY-MM-DD)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: endDateController,
              decoration: const InputDecoration(
                labelText: 'End Date (YYYY-MM-DD)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: submitRequest,
              child: const Text('Submit'),
            ),
            const Divider(height: 30),
            const Text(
              'Previous Requests',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            if (loading) const CircularProgressIndicator(),
            if (!loading && leaveRequests.isEmpty)
              const Text("No leave requests yet."),
            for (final r in leaveRequests)
              ListTile(
                title: Text('${r.startDate} → ${r.endDate}'),
                subtitle: Text(r.reason),
              ),
          ],
        ),
      ),
    );
  }
}
