import 'package:employee_details_assignment/models/employee.dart';
import 'package:employee_details_assignment/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final String id;

  EmployeeDetailScreen({required this.id}) {
    // Debug statement to check received employee.id
    print('Received Employee ID: $id');
  }

  @override
  Widget build(BuildContext context) {
    String? name;
    int? salary;
    int? age;
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              try {
                await employeeProvider.deleteEmployee(id);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Employee deleted successfully'),
                ));
                Navigator.pop(context, true); // Indicate successful deletion
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Failed to delete employee: $e'),
                ));
              }
            },
          ),
        ],
      ),

      body: FutureBuilder(
        future: employeeProvider.fetchEmployeeById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final employee = snapshot.data! as Employee;
            print(
                'Fetched Employee: ${employee.id}, ${employee.name}, ${employee.salary}, ${employee.age}');
            return each_employee(context, employee);
          }
        },
      ),
    );
  }

  Widget each_employee(BuildContext context, Employee employee) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: employee.name,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) => employee.name = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                employee.name = value;
                return null;
              },
            ),
            TextFormField(
              initialValue: employee.salary?.toString(),
              decoration: InputDecoration(labelText: 'Salary'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(7),
              ],
              onChanged: (value) {
                employee.salary = int.tryParse(value); // Correct parsing for age
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the salary';
                }
                final parsedValue = int.tryParse(value);
                if (parsedValue == null) {
                  return 'Please enter a valid number';
                }
                employee.salary = parsedValue; // Assign the parsed integer value
                return null;
              },
            ),
            TextFormField(
              initialValue: employee.age?.toString(),
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              onChanged: (value) {
                employee.age = int.tryParse(value); // Correct parsing for age
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a age';
                }
                final parsedValue = int.tryParse(value);
                if (parsedValue == null) {
                  return 'Please enter a valid number';
                }
                employee.age = parsedValue; // Assign the parsed integer value
                return null;
              },
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    employeeProvider.updateEmployee(employee).then((_) {
                      employeeProvider.fetchEmployees();
                      Navigator.pop(context);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update employee')),
                      );
                    });
                  }
                },
                child: Text('Update Employee'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}