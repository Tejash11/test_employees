import 'package:employee_details_assignment/models/employee.dart';
import 'package:employee_details_assignment/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddEmployeeScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _salaryController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Add Employee')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a salary';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10), // Limits the input to 10 characters
                ],
                onChanged: (text) {
                  if (text.length > 3) {
                    _ageController.text = text.substring(0, 3);
                    _ageController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _ageController.text.length),
                    );
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a employee age';
                  }
                  if (value.length > 10) {
                    return 'Age cannot exceed 3 digits';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newEmployee = Employee(
                        id: '',
                        // ID will be generated by the server
                        employee_name: _nameController.text,
                        employee_salary: int.parse(_salaryController.text),
                        employee_age: int.parse(_ageController.text),
                        );
                    employeeProvider.createEmployee(newEmployee);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Employee'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}