import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vlad_diplome/data/model/employee.dart';
import 'package:vlad_diplome/data/utils/extensions.dart';
import 'package:vlad_diplome/data/utils/styles.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/dialogs/employee_update_dialog.dart';
import 'package:vlad_diplome/ui/widgets/apppage.dart';
import 'package:vlad_diplome/ui/widgets/loading.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({Key? key}) : super(key: key);

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  @override
  void initState() {
    appBloc.callEmployeesStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: "Сотрудники",
      child: StreamBuilder(
        stream: appBloc.employeesStream,
        builder: (context, AsyncSnapshot<List<Employee>?> snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.isNotEmpty){
              return employeesTable(snapshot.data!);
            }
            return const Center(child: Text("EMPTY LIST"));
          }
          return const LoadingView();
        },
      ),
    );
  }

  Widget employeesTable(List<Employee> em) {
    return Table(
      border: TableBorder.all(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade800,
        width: 1.5
      ),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(6),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: em.asMap().map((index, employee){
        return MapEntry(index, TableRow(children: [
          tableCell((index + 1).toString(), isTitle: true),
          tableCell("${employee.surname} ${employee.name} ${employee.secondName}"),
          tableCell(employee.phone != null ? (employee.phone!.isNotEmpty ?
              employee.phone! : "-") : "-", isTitle: true),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CupertinoSwitch(
                value: employee.isEnabled!,
                activeColor: appColor,
                onChanged: (value) async{
                  setState(() => employee.isEnabled = !employee.isEnabled!);
                  await appBloc.updateEmployee(employee.key!, employee.toJson());
                }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: PopupMenuButton<int>(
                itemBuilder: (context) => [
                  // PopupMenuItem 1
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: const [
                        Icon(Icons.edit, color: Colors.white),
                        SizedBox(
                          width: 6,
                        ),
                        Text("Изменить")
                      ],
                    ),
                  ),
                  // PopupMenuItem 2
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: const [
                        Icon(Icons.delete_outline, color: Colors.white),
                        SizedBox(
                          width: 6,
                        ),
                        Text("Удалить")
                      ],
                    ),
                  ),
                ],
                elevation: 2,
                onSelected: (value) {
                  if (value == 1) {
                    showCustomDialog(context, EmployeeUpdateDialog(
                      employee: employee,
                      updateFunc: (emp){
                        setState(() => employee = emp);
                      },
                    ));
                  }
                  else if (value == 2) {
                    //_showDialog(context);
                  }
                },
              ),
            ),
          ),
        ]));
      }).values.toList()..insert(0, TableRow(children: [
        tableCell("ID", isTitle: true),
        tableCell("ФИО", isTitle: true),
        tableCell("Телефон", isTitle: true),
        tableCell("Аккаунт", isTitle: true),
        tableCell("", isTitle: true),
      ])),
    );
  }
}
