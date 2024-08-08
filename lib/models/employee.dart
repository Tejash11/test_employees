class Employee {
  String? id;
  String? employee_name;
  int? employee_salary;
  int? employee_age;

  Employee({required this.id, required this.employee_name, required this.employee_salary, required this.employee_age});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'],
      employee_name: json['name'],
      employee_salary: json['salary'],
      employee_age: json['age'],
    );
  }
}