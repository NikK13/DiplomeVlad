import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vlad_diplome/data/model/employee.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/input.dart';

class EmployeeUpdateDialog extends StatefulWidget {
  final Employee? employee;
  final Function? updateFunc;

  const EmployeeUpdateDialog({Key? key, this.employee, this.updateFunc}) : super(key: key);

  @override
  State<EmployeeUpdateDialog> createState() => _EmployeeUpdateDialogState();
}

class _EmployeeUpdateDialogState extends State<EmployeeUpdateDialog> {
  late Employee currentEmployee;

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _secNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    currentEmployee = widget.employee!;
    if(currentEmployee.phone != null){
      _phoneController.text = currentEmployee.phone!;
    }
    _nameController.text = currentEmployee.name!;
    _surnameController.text = currentEmployee.surname!;
    _secNameController.text = currentEmployee.secondName!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(
              hint: "Фамилия",
              controller: _surnameController,
            ),
            const SizedBox(height: 8),
            InputField(
              hint: "Имя",
              controller: _nameController,
            ),
            const SizedBox(height: 8),
            InputField(
              hint: "Отчество",
              controller: _secNameController,
            ),
            const SizedBox(height: 8),
            InputField(
              hint: "Телефон",
              controller: _phoneController,
            ),
            const SizedBox(height: 8),
            AppButton(
              text: "Сохранить",
              onPressed: () async{
                final name = _nameController.text.trim();
                final surN = _surnameController.text.trim();
                final secN = _secNameController.text.trim();
                if(name.isNotEmpty && surN.isNotEmpty && secN.isNotEmpty){
                  currentEmployee.name = name;
                  currentEmployee.surname = surN;
                  currentEmployee.secondName = secN;
                  currentEmployee.phone = _phoneController.text.trim();
                  Navigator.pop(context);
                  await widget.updateFunc!(currentEmployee);
                  await appBloc.updateEmployee(currentEmployee.key!, currentEmployee.toJson());
                }
                else{
                  Fluttertoast.showToast(msg: "Заполните поля ФИО");
                }
              }
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _surnameController.dispose();
    _nameController.dispose();
    _secNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
