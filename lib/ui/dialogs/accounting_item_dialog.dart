import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vlad_diplome/data/model/accounting_item.dart';
import 'package:vlad_diplome/data/utils/constants.dart';
import 'package:vlad_diplome/data/utils/lists.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/dropdown.dart';
import 'package:vlad_diplome/ui/widgets/input.dart';

class AccountingItemDialog extends StatefulWidget {
  final AccountingItem? accountingItem;

  const AccountingItemDialog({Key? key, this.accountingItem}) : super(key: key);

  @override
  State<AccountingItemDialog> createState() => _AccountingItemDialogState();
}

class _AccountingItemDialogState extends State<AccountingItemDialog> {
  late ListItem material;
  late ListItem stock;

  List<ListItem> listMaterials = [];
  List<ListItem> listStocks = [];

  final _countController = TextEditingController();

  @override
  void initState() {
    for(var item in appBloc.stocksList){
      listStocks.add(ListItem(item.name!, item.key!));
    }
    for(var item in appBloc.materialsList){
      listMaterials.add(ListItem(item.name!, item.key!));
    }
    if(widget.accountingItem == null){
      material = listMaterials.first;
      stock = listStocks.first;
    }
    else{
      material = listMaterials.firstWhere((element) => element.value == widget.accountingItem!.materialKey);
      stock = listStocks.firstWhere((element) => element.value == widget.accountingItem!.stockKey);
      _countController.text = widget.accountingItem!.count.toString();
    }
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: DropdownPicker(
                    title: "Материал",
                    myValue: material.value,
                    items: listMaterials,
                    darkColor: const Color(0xFF242424),
                    onChange: (newVal){
                      setState(() => material = listMaterials.firstWhere((element) => element.value == newVal));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InputField(
                    hint: "Количество",
                    controller: _countController,
                    inputType: const TextInputType.numberWithOptions(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownPicker(
              title: "Склад",
              myValue: stock.value,
              items: listStocks,
              darkColor: const Color(0xFF242424),
              onChange: (newVal){
                setState(() => stock = listStocks.firstWhere((element) => element.value == newVal));
              },
            ),
            const SizedBox(height: 16),
            AppButton(
              text: widget.accountingItem == null ?
              "Добавить" : "Сохранить",
              onPressed: () async{
                final count = _countController.text.trim();
                if(count.isNotEmpty){
                  final item = appBloc.materialsList.firstWhere((element) => element.key == material.value);
                  if(int.parse(count) <= item.leftCount!){
                    Navigator.pop(context);
                    final newItem = AccountingItem(
                      stockKey: stock.value,
                      materialKey: material.value,
                      date: DateFormat(dateFormat24h).format(DateTime.now()),
                      employeeKey: firebaseBloc.fbUser!.uid,
                      count: int.parse(count)
                    );
                    if(widget.accountingItem == null){
                      await appBloc.createAccounting(newItem);
                      await appBloc.updateMaterialLeftCount(material.value, item.leftCount! - int.parse(count));
                    }
                    else{
                      await appBloc.updateAccounting(newItem, widget.accountingItem!.key!);
                      await appBloc.updateMaterialLeftCount(material.value, item.leftCount! + widget.accountingItem!.count! - int.parse(count));
                    }
                    await appBloc.callAccountingStreams();
                    await appBloc.callMaterialsStream();
                  }
                  else{
                    Fluttertoast.showToast(msg: "Вы ввели количество материалов"
                    " большее, чем доступно на складе");
                  }
                }
                else{
                  Fluttertoast.showToast(msg: "Заполните поля");
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
    _countController.dispose();
    super.dispose();
  }
}
