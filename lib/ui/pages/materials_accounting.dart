import 'package:flutter/material.dart';
import 'package:vlad_diplome/data/model/accounting_item.dart';
import 'package:vlad_diplome/data/model/employee.dart';
import 'package:vlad_diplome/data/model/material_item.dart';
import 'package:vlad_diplome/data/model/stock.dart';
import 'package:vlad_diplome/data/utils/constants.dart';
import 'package:vlad_diplome/data/utils/extensions.dart';
import 'package:vlad_diplome/data/utils/lists.dart';
import 'package:vlad_diplome/data/utils/styles.dart';
import 'package:vlad_diplome/main.dart';
import 'package:collection/collection.dart';
import 'package:vlad_diplome/ui/dialogs/accounting_item_dialog.dart';
import 'package:vlad_diplome/ui/dialogs/left_count_dialog.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/dropdown.dart';
import 'package:vlad_diplome/ui/widgets/loading.dart';

class MaterialsAccountingPage extends StatefulWidget {
  const MaterialsAccountingPage({Key? key}) : super(key: key);

  @override
  State<MaterialsAccountingPage> createState() => _MaterialsAccountingPageState();
}

class _MaterialsAccountingPageState extends State<MaterialsAccountingPage> {
  late ListItem _selectedSort;
  List<ListItem> sortItems = [];

  String? userEditKey;

  initData() async{
    sortItems.add(ListItem("Все", 'all'));
    _selectedSort = sortItems.first;
    await appBloc.callStocksStreams();
    for (var element in appBloc.stocksList) {
      sortItems.add(ListItem(element.name!, element.key!));
    }
    await appBloc.callAccountingStreams();
    setState(() {});
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 16, right: 12),
      child: StreamBuilder(
        stream: appBloc.accountingStream,
        builder: (context, AsyncSnapshot<List<AccountingItem>?> snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.isNotEmpty){
              final item = snapshot.data!.lastWhereOrNull((element) =>
              element.employeeKey == firebaseBloc.fbAuth.currentUser!.uid);
              userEditKey = !isAsAdministrator ?
              item?.key : null;
              return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width < 300 ?
                    MediaQuery.of(context).size.width : 300,
                    child: AppButton(
                      text: "Добавить",
                      onPressed: (){
                        showCustomDialog(context, const AccountingItemDialog());
                      }
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: (){
                      showCustomDialog(context, const LeftCountDialog());
                    },
                    child: const Text(
                      "Рассчитать остаток",
                      style: TextStyle(color: appColor),
                    )
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: MediaQuery.of(context).size.width > 400 ? 400 :
                    MediaQuery.of(context).size.width,
                    child: DropdownPicker(
                      title: "Склады",
                      myValue: _selectedSort.value,
                      items: sortItems,
                      darkColor: const Color(0xFF242424),
                      onChange: (newVal) async{
                        if(newVal == "all"){
                          await appBloc.callAccountingStreams();
                        }
                        else{
                          await appBloc.callAccountingStreams(newVal);
                        }
                        setState(() => _selectedSort = sortItems.firstWhere((element) => element.value == newVal));
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  childTable(snapshot.data!),
                ],
              );
            }
            return Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width < 300 ?
                  MediaQuery.of(context).size.width : 300,
                  child: AppButton(
                    text: "Добавить",
                    onPressed: (){
                      showCustomDialog(context, const AccountingItemDialog());
                    }
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: MediaQuery.of(context).size.width > 400 ? 400 :
                  MediaQuery.of(context).size.width,
                  child: DropdownPicker(
                    title: "Склады",
                    myValue: _selectedSort.value,
                    items: sortItems,
                    darkColor: const Color(0xFF242424),
                    onChange: (newVal) async{
                      if(newVal == "all"){
                        await appBloc.callAccountingStreams();
                      }
                      else{
                        await appBloc.callAccountingStreams(newVal);
                      }
                      setState(() => _selectedSort = sortItems.firstWhere((element) => element.value == newVal));
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Expanded(child: Center(child: Text("Пока здесь пусто")))
              ],
            );
          }
          return const LoadingView();
        },
      ),
    );
  }

  Widget childTable(List<AccountingItem> types) {
    return Table(
      border: TableBorder.all(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade800,
        width: 1.5
      ),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(4),
        3: FlexColumnWidth(4),
        4: FlexColumnWidth(4),
        5: FlexColumnWidth(2),
        6: FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: types.asMap().map((index, item){
        Employee? emp = item.employeeKey != adminId ?
        appBloc.employeesList.firstWhere((element) => element.key == item.employeeKey!) : null;
        StockItem? stock = appBloc.stocksList.firstWhere((element) => element.key == item.stockKey!);
        MaterialItem? material = appBloc.materialsList.firstWhere((element) => element.key == item.materialKey!);
        return MapEntry(index, TableRow(children: [
          tableCell((index + 1).toString(), isTitle: false),
          tableCell(item.date!, isTitle: false),
          if(emp != null)
          tableCell("${emp.surname} ${emp.name} ${emp.secondName}", isTitle: false)
          else tableCell("Administrator", isTitle: false),
          tableCell("${stock.name} ${stock.address}", isTitle: false),
          tableCell("${material.name}", isTitle: false),
          tableCell("${item.count}", isTitle: false),
          if(isAsAdministrator)
          IconButton(
            onPressed: () async{
              showCustomDialog(context, AccountingItemDialog(accountingItem: item));
            },
            icon: Icon(Icons.edit, color: Colors.grey.shade600)
          )
          else userEditKey != null ?
          (item.key == userEditKey ?
          IconButton(
            onPressed: () async{
              showCustomDialog(context, AccountingItemDialog(accountingItem: item));
            },
            icon: Icon(Icons.edit, color: Colors.grey.shade600)
          ) : const SizedBox()) : const SizedBox()
        ]));
      }).values.toList()..insert(0, TableRow(children: [
        tableCell("", isTitle: true),
        tableCell("Дата добавления", isTitle: true),
        tableCell("Сотрудник", isTitle: true),
        tableCell("Склад", isTitle: true),
        tableCell("Материал", isTitle: true),
        tableCell("Кол-во", isTitle: true),
        tableCell("", isTitle: true),
      ])),
    );
  }
}
