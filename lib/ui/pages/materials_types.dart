import 'package:flutter/material.dart';
import 'package:vlad_diplome/data/model/material_types.dart';
import 'package:vlad_diplome/data/utils/extensions.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/dialogs/new_material_type_dialog.dart';
import 'package:vlad_diplome/ui/widgets/apppage.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/loading.dart';

class MaterialsTypesListPage extends StatefulWidget {
  const MaterialsTypesListPage({Key? key}) : super(key: key);

  @override
  State<MaterialsTypesListPage> createState() => _MaterialsTypesListPageState();
}

class _MaterialsTypesListPageState extends State<MaterialsTypesListPage> {
  @override
  void initState() {
    appBloc.callMaterialsTypesStreams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 16, right: 12),
      child: StreamBuilder(
        stream: appBloc.materialsTypesStream,
        builder: (context, AsyncSnapshot<List<MaterialsTypes>?> snapshot){
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
                        showCustomDialog(context, const NewMaterialTypeDialog());
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
                      showCustomDialog(context, const NewMaterialTypeDialog());
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

  Widget childTable(List<MaterialsTypes> types) {
    return Table(
      border: TableBorder.all(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade800,
        width: 1.5
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(6),
        //2: FlexColumnWidth(2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: types.asMap().map((index, item){
        return MapEntry(index, TableRow(children: [
          tableCell((index + 1).toString(), isTitle: false),
          tableCell(item.name!, isTitle: false),
          /*IconButton(
            onPressed: () async{
              //await appBloc.deleteMaterialType(item.key!);
            },
            icon: const Icon(Icons.delete, color: Colors.white)
          ),*/
        ]));
      }).values.toList()..insert(0, TableRow(children: [
        tableCell("", isTitle: true),
        tableCell("Наименование", isTitle: true),
        //tableCell("", isTitle: true),
      ])),
    );
  }
}