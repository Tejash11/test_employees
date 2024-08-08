import 'package:employee_details_assignment/providers/employee_provider.dart';
import 'package:employee_details_assignment/screens/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EmployeeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Details',
      home: EmployeeListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
