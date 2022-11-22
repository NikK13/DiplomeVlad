import 'package:vlad_diplome/data/model/employee.dart';
import 'package:vlad_diplome/data/model/material_item.dart';
import 'package:vlad_diplome/data/model/material_types.dart';
import 'package:vlad_diplome/ui/bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc extends BaseBloc{
  final List<Employee> employeesList = [];
  final List<MaterialItem> materialsList = [];
  final List<MaterialsTypes> materialsTypesList = [];

  final _employees = BehaviorSubject<List<Employee>?>();
  final _materials = BehaviorSubject<List<MaterialItem>?>();
  final _materialsTypes = BehaviorSubject<List<MaterialsTypes>?>();

  Stream<List<Employee>?> get employeesStream => _employees.stream;
  Stream<List<MaterialItem>?> get materialsStream => _materials.stream;
  Stream<List<MaterialsTypes>?> get materialsTypesStream => _materialsTypes.stream;

  Function(List<Employee>?) get loadAllEmployees => _employees.sink.add;
  Function(List<MaterialItem>?) get loadAllMaterials => _materials.sink.add;
  Function(List<MaterialsTypes>?) get loadAllMaterialsTypes => _materialsTypes.sink.add;

  Future<void> callMaterialsTypesStreams() async{
    if(materialsTypesList.isNotEmpty){
      materialsTypesList.clear();
    }
    materialsTypesList.addAll((await loadMaterialsTypes())!.toList());
    await loadAllMaterialsTypes(materialsTypesList);
  }

  Future<void> callEmployeesStream() async{
    await loadAllEmployees(null);
    if(employeesList.isNotEmpty){
      employeesList.clear();
    }
    employeesList.addAll((await loadEmployees())!.toList());
    await loadAllEmployees(employeesList);
  }

  Future<void> callMaterialsStream() async{
    await loadAllMaterials(null);
    if(materialsList.isNotEmpty){
      materialsList.clear();
    }
    materialsList.addAll((await loadMaterials())!.toList());
    await loadAllMaterials(materialsList);
  }

  Future<List<Employee>?> loadEmployees() async{
    final query = await FirebaseDatabase.instance.ref("employees").once();
    if(query.snapshot.exists){
      final List<Employee> employees = [];
      final data = query.snapshot.children;
      for(var item in data){
        final emp = Employee.fromJson(item.key!, item.value as Map<String, dynamic>);
        employees.add(emp);
      }
      return employees;
    }
    else{
      return [];
    }
  }

  Future<List<MaterialsTypes>?> loadMaterialsTypes() async{
    final query = await FirebaseDatabase.instance.ref("materialsTypes").once();
    if(query.snapshot.exists){
      final List<MaterialsTypes> list = [];
      final data = query.snapshot.children;
      for(var item in data){
        final singleItem = MaterialsTypes.fromJson(item.key!, item.value as Map<String, dynamic>);
        list.add(singleItem);
      }
      return list;
    }
    else{
      return [];
    }
  }

  Future<List<MaterialItem>?> loadMaterials() async{
    final query = await FirebaseDatabase.instance.ref("materials").once();
    if(query.snapshot.exists){
      final List<MaterialItem> list = [];
      final data = query.snapshot.children;
      for(var item in data){
        final singleItem = MaterialItem.fromJson(item.key!, item.value as Map<String, dynamic>);
        list.add(singleItem);
      }
      return list;
    }
    else{
      return [];
    }
  }

  Future<void> updateEmployee(String key, Map<String, Object?> item) async{
    final ref = FirebaseDatabase.instance.ref("employees/$key");
    await ref.update(item);
  }

  Future<void> createMaterialsType(String name) async{
    final ref = FirebaseDatabase.instance.ref("materialsTypes").push();
    await ref.set({"name": name});
  }

  Future<void> createMaterial(MaterialItem item) async{
    final ref = FirebaseDatabase.instance.ref("materials").push();
    await ref.set(item.toJson());
    await ref.update({"left_count": item.allCount!});
  }

  Future<void> deleteMaterialType(String key) async{
    await FirebaseDatabase.instance.ref("materialsTypes/$key").remove();
    await callMaterialsTypesStreams();
  }

  @override
  void dispose() {
    _employees.close();
    _materials.close();
    _materialsTypes.close();
  }
}
