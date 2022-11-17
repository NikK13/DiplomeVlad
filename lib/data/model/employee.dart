import 'dart:convert';

class Employee{
  String? key;
  String? name;
  String? email;
  String? phone;
  String? surname;
  String? secondName;
  bool? isEnabled;

  Employee({
    this.key,
    this.name,
    this.email,
    this.phone,
    this.surname,
    this.secondName,
    this.isEnabled
  });

  factory Employee.fromJson(String key, Map<String, dynamic> json){
    return Employee(
      key: key,
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      surname: json['surname'],
      secondName: json['second_name'],
      isEnabled: json['is_activated']
    );
  }

  Map<String, Object?> toJson() => {
    'name': name,
    'surname': surname,
    'second_name': secondName,
    'is_activated': isEnabled,
    'phone': phone,
  };
}
