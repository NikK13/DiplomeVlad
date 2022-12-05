import 'package:flutter/material.dart';
import 'package:vlad_diplome/data/model/vendor.dart';
import 'package:vlad_diplome/data/utils/extensions.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/dialogs/new_material_type_dialog.dart';
import 'package:vlad_diplome/ui/dialogs/new_vendor_dialog.dart';
import 'package:vlad_diplome/ui/widgets/apppage.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/loading.dart';

class VendorsListPage extends StatefulWidget {
  const VendorsListPage({Key? key}) : super(key: key);

  @override
  State<VendorsListPage> createState() => _VendorsListPageState();
}

class _VendorsListPageState extends State<VendorsListPage> {
  @override
  void initState() {
    appBloc.callVendorsStreams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: "Поставщики",
      child: StreamBuilder(
        stream: appBloc.vendorsStream,
        builder: (context, AsyncSnapshot<List<VendorItem>?> snapshot){
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
                        showCustomDialog(context, const NewVendorDialog());
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
                      showCustomDialog(context, const NewVendorDialog());
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

  Widget childTable(List<VendorItem> items) {
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
      children: items.asMap().map((index, item){
        return MapEntry(index, TableRow(children: [
          tableCell((index + 1).toString(), isTitle: true),
          tableCell(item.name!, isTitle: true),
         /* IconButton(
            onPressed: () async{
              //await appBloc.deleteMaterialType(item.key!);
            },
            icon: const Icon(Icons.delete, color: Colors.white)
          ),*/
        ]));
      }).values.toList()..insert(0, TableRow(children: [
        tableCell("ID", isTitle: true),
        tableCell("Наименование", isTitle: true),
        //tableCell("", isTitle: true),
      ])),
    );
  }
}