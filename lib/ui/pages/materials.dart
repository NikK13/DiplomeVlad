import 'package:flutter/material.dart';
import 'package:vlad_diplome/data/model/material_item.dart';
import 'package:vlad_diplome/data/utils/extensions.dart';
import 'package:vlad_diplome/data/utils/lists.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/dialogs/new_material_dialog.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/dropdown.dart';
import 'package:vlad_diplome/ui/widgets/loading.dart';

class MaterialsListPage extends StatefulWidget {
  const MaterialsListPage({Key? key}) : super(key: key);

  @override
  State<MaterialsListPage> createState() => _MaterialsListPageState();
}

class _MaterialsListPageState extends State<MaterialsListPage> {
  late ListItem _selectedSort;
  List<ListItem> sortItems = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async{
    sortItems.add(ListItem("Все", 'all'));
    _selectedSort = sortItems.first;
    await appBloc.callVendorsStreams();
    for (var element in appBloc.vendorsList) {
      sortItems.add(ListItem(element.name!, element.key!));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 16, right: 12),
      child: StreamBuilder(
        stream: appBloc.materialsStream,
        builder: (context, AsyncSnapshot<List<MaterialItem>?> snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.isNotEmpty){
              return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width < 300 ?
                    MediaQuery.of(context).size.width : 300,
                    child: AppButton(
                      text: "Добавить",
                      onPressed: (){
                        showCustomDialog(context, const NewMaterialDialog());
                      }
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: MediaQuery.of(context).size.width > 400 ? 400 :
                    MediaQuery.of(context).size.width,
                    child: DropdownPicker(
                      title: "Поставщики",
                      myValue: _selectedSort.value,
                      items: sortItems,
                      darkColor: const Color(0xFF242424),
                      onChange: (newVal) async{
                        if(newVal == "all"){
                          await appBloc.callMaterialsStream();
                        }
                        else{
                          await appBloc.callMaterialsStream(newVal);
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
                      showCustomDialog(context, const NewMaterialDialog());
                    }
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: MediaQuery.of(context).size.width > 400 ? 400 :
                  MediaQuery.of(context).size.width,
                  child: DropdownPicker(
                    title: "Поставщики",
                    myValue: _selectedSort.value,
                    items: sortItems,
                    darkColor: const Color(0xFF242424),
                    onChange: (newVal) async{
                      if(newVal == "all"){
                        await appBloc.callMaterialsStream();
                      }
                      else{
                        await appBloc.callMaterialsStream(newVal);
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

  Widget childTable(List<MaterialItem> types) {
    return Table(
      border: TableBorder.all(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade800,
        width: 1.5
      ),
      columnWidths: {
        0: const FlexColumnWidth(1),
        1: const FlexColumnWidth(2),
        2: const FlexColumnWidth(2),
        3: const FlexColumnWidth(3),
        4: const FlexColumnWidth(1),
        5: const FlexColumnWidth(1),
        6: const FlexColumnWidth(3),
        if(isAsAdministrator)
        7: const FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: types.asMap().map((index, item){
        return MapEntry(index, TableRow(children: [
          tableCell((index + 1).toString(), isTitle: true),
          tableCell(item.name!),
          tableCell(
            appBloc.materialsTypesList.
            firstWhere((element) => element.key == item.type!).name!,
          ),
          tableCell(appBloc.vendorsList.firstWhere((element)
          => element.key == item.vendor!).name!),
          tableCell(item.allCount!.toString()),
          tableCell(item.pricePerItem.toString()),
          tableCell(item.desc!.isEmpty ? "-" : item.desc!),
          if(isAsAdministrator)
          IconButton(
            onPressed: () async{
              showCustomDialog(context, NewMaterialDialog(materialItem: item));
            },
            icon: Icon(Icons.edit, color: Colors.grey.shade600)
          ),
        ]));
      }).values.toList()..insert(0, TableRow(children: [
        tableCell("", isTitle: true),
        tableCell("Название", isTitle: true),
        tableCell("Вид материала", isTitle: true),
        tableCell("Поставщик", isTitle: true),
        tableCell("Единиц", isTitle: true),
        tableCell("Цена за ед.", isTitle: true),
        tableCell("Описание", isTitle: true),
        if(isAsAdministrator)
        tableCell("", isTitle: true),
      ])),
    );
  }
}
