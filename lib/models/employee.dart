class Employee {
  String? id;
  String? name;
  int? salary;
  int? age;

  Employee({required this.id, required this.name, required this.salary, required this.age});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'] as String,
      name: json['name'] as String,
      salary: int.tryParse(json['salary']?.toString() ?? '') ?? 0,  // Safely parse salary
      age: int.tryParse(json['age']?.toString() ?? '') ?? 0,        // Safely parse age

    );
  }
}