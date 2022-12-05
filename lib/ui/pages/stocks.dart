import 'package:flutter/material.dart';
import 'package:vlad_diplome/data/model/material_types.dart';
import 'package:vlad_diplome/data/model/stock.dart';
import 'package:vlad_diplome/data/utils/extensions.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/dialogs/new_material_type_dialog.dart';
import 'package:vlad_diplome/ui/dialogs/new_stock_dialog.dart';
import 'package:vlad_diplome/ui/widgets/apppage.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/loading.dart';

class StocksListPage extends StatefulWidget {
  const StocksListPage({Key? key}) : super(key: key);

  @override
  State<StocksListPage> createState() => _StocksListPageState();
}

class _StocksListPageState extends State<StocksListPage> {
  @override
  void initState() {
    appBloc.callStocksStreams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: "Склады",
      child: StreamBuilder(
        stream: appBloc.stocksStream,
        builder: (context, AsyncSnapshot<List<StockItem>?> snapshot){
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
                        showCustomDialog(context, const NewStockDialog());
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
                      showCustomDialog(context, const NewStockDialog());
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

  Widget childTable(List<StockItem> items) {
    return Table(
      border: TableBorder.all(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade800,
        width: 1.5
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(6),
        //4: FlexColumnWidth(1.5),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: items.asMap().map((index, item){
        return MapEntry(index, TableRow(children: [
          tableCell((index + 1).toString(), isTitle: true),
          tableCell(item.name!, isTitle: true),
          tableCell(item.address!, isTitle: true),
          /*IconButton(
            onPressed: () async{
              //await appBloc.deleteMaterialType(item.key!);
            },
            icon: const Icon(Icons.delete, color: Colors.white)
          ),*/
        ]));
      }).values.toList()..insert(0, TableRow(children: [
        tableCell("ID", isTitle: true),
        tableCell("Наименование", isTitle: true),
        tableCell("Адрес", isTitle: true),
        //tableCell("", isTitle: true),
      ])),
    );
  }
}