import 'dart:convert';

import 'package:employee_details_assignment/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmployeeProvider with ChangeNotifier {
  final baseUrl = 'https://free-ap-south-1.cosmocloud.io/development/api/test_employees';
  final limit = '200';
  final offset = '0';

  //function to fetch the list of all employees
  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(
      Uri.parse('$baseUrl?limit=$limit&offset=$offset'),
      headers: {
        'Content-Type': 'application/json',
        'projectId': '66aa089339e2fdc09bbba300',
        'environmentId': '66aa089339e2fdc09bbba301',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> employeesJson = data['data']; //updated
      return employeesJson.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  //function to fetch the employee details by their id's
  Future<Employee> fetchEmployeeById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'projectId': '66aa089339e2fdc09bbba300',
        'environmentId': '66aa089339e2fdc09bbba301',
      },
    );
    if (response.statusCode == 200) {
      return Employee.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load employee');
    }
  }

  //function to create a new employee detail
  Future<void> createEmployee(Employee employee) async {
    final response = await http.post(Uri.parse('$baseUrl'),
      headers: {
        'Content-Type': 'application/json',
        'projectId': '66aa089339e2fdc09bbba300',
        'environmentId': '66aa089339e2fdc09bbba301',
      },
      body: json.encode({
        'name': employee.employee_name,
        'salary': employee.employee_salary,
        'age': employee.employee_age,
      }),
    );

    if (response.statusCode == 201) {
      // Employee created successfully
      fetchEmployees();
      notifyListeners();// Refreshing the list of employees
    } else {
      throw Exception('Failed to create employee');
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/${employee.id}'),
      headers: {
        'Content-Type': 'application/json',
        'projectId': '66aa089339e2fdc09bbba300',
        'environmentId': '66aa089339e2fdc09bbba301',
      },
      body: json.encode({
        'name': employee.employee_name,
        'salary': employee.employee_salary,
        'age': employee.employee_age,
      }),
    );

    if (response.statusCode == 200) {
      // Employee updated successfully
      fetchEmployees();
      notifyListeners(); // Refresh the list of employees
    } else {
      throw Exception('Failed to update employee');
    }
  }

  //function to delete single employee
  Future<void> deleteEmployee(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'projectId': '66aa089339e2fdc09bbba300',
          'environmentId': '66aa089339e2fdc09bbba301',
        },
        body: jsonEncode({})
    );

    if (response.statusCode == 200) {
      // Employee deleted successfully
      notifyListeners();
    } else {
      throw Exception('Failed to delete employee');
    }
  }

}