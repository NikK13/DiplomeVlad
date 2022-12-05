import 'package:flutter/material.dart';
import 'package:vlad_diplome/data/model/material_item.dart';
import 'package:vlad_diplome/data/utils/extensions.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/dialogs/new_material_dialog.dart';
import 'package:vlad_diplome/ui/widgets/apppage.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/loading.dart';

class MaterialsListPage extends StatelessWidget {
  const MaterialsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: "Материалы",
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
                const SizedBox(height: 16),
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
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(3),
        4: FlexColumnWidth(2),
        5: FlexColumnWidth(2),
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
        ]));
      }).values.toList()..insert(0, TableRow(children: [
        tableCell("ID", isTitle: true),
        tableCell("Название", isTitle: true),
        tableCell("Вид материала", isTitle: true),
        tableCell("Поставщик", isTitle: true),
        tableCell("Ед.осталось", isTitle: true),
        tableCell("Цена за ед.", isTitle: true),
      ])),
    );
  }
}
