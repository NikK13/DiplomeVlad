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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 16, right: 12),
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
      columnWidths: {
        0: const FlexColumnWidth(2),
        1: const FlexColumnWidth(6),
        if(isAsAdministrator)
        2: const FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: items.asMap().map((index, item){
        return MapEntry(index, TableRow(children: [
          tableCell((index + 1).toString(), isTitle: false),
          tableCell(item.name!, isTitle: false),
          if(isAsAdministrator)
          IconButton(
            onPressed: (){
              showCustomDialog(context, NewVendorDialog(vendorItem: item));
            },
            icon: Icon(Icons.edit, color: Colors.grey.shade600)
          ),
        ]));
      }).values.toList()..insert(0, TableRow(children: [
        tableCell("", isTitle: true),
        tableCell("Наименование", isTitle: true),
        if(isAsAdministrator)
        tableCell("", isTitle: true),
      ])),
    );
  }
}