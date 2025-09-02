import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'providers/employee_provider.dart';
import 'providers/leave_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => EmployeeProvider()),
    ChangeNotifierProvider(create: (_) => LeaveProvider()), // ✅ Add this
  ],
  child: const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ),
);
  }
}
