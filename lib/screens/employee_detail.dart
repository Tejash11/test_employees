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
                'Fetched Employee: ${employee.id}, ${employee.employee_name}, ${employee.employee_salary}, ${employee.employee_age}');
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
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Text('Id: ${employee.id}', style: TextStyle(fontSize: 16)),
      //     SizedBox(height: 8),
      //     Text('Name: ${employee.employee_name}', style: TextStyle(fontSize: 14)),
      //     SizedBox(height: 8),
      //     Text('Salary: ${employee.employee_salary}', style: TextStyle(fontSize: 14)),
      //     SizedBox(height: 8),
      //     Text('Age: ${employee.employee_age}', style: TextStyle(fontSize: 14)),
      //   ],
      // ),

      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: employee.employee_name,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) => employee.employee_name = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                employee.employee_name = value;
                return null;
              },
            ),
            TextFormField(
              initialValue: employee.employee_salary?.toString(),
              decoration: InputDecoration(labelText: 'Salary'),
              onChanged: (value) => employee.employee_salary = int.tryParse(value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the salary';
                }
                employee.employee_salary = value as int?;
                return null;
              },
            ),
            TextFormField(
              initialValue: employee.employee_age?.toString(),
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              onChanged: (value) => employee.employee_age = int.tryParse(value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a contact number';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                employee.employee_age = value as int?;
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedEmployee = Employee(
                    id: id,
                    employee_name: employee.employee_name!,
                    employee_salary: employee.employee_salary!,
                    employee_age: int.parse(employee.employee_age! as String),
                  );
                  employeeProvider.updateEmployee(updatedEmployee).then((_) {
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
          ],
        ),
      ),
    );
  }
}