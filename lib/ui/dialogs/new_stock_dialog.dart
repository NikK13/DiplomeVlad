import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vlad_diplome/data/model/stock.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/input.dart';

class NewStockDialog extends StatefulWidget {
  final StockItem? stockItem;

  const NewStockDialog({Key? key, this.stockItem}) : super(key: key);

  @override
  State<NewStockDialog> createState() => _NewStockDialogState();
}

class _NewStockDialogState extends State<NewStockDialog> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    if(widget.stockItem != null){
      _nameController.text = widget.stockItem!.name!;
      _addressController.text = widget.stockItem!.address!;
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
            InputField(
              hint: "Название",
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            InputField(
              hint: "Адрес",
              controller: _addressController,
            ),
            const SizedBox(height: 16),
            AppButton(
              text: widget.stockItem == null ?
              "Добавить" : "Сохранить",
              onPressed: () async{
                final name = _nameController.text.trim();
                final address = _addressController.text.trim();
                if(name.isNotEmpty && address.isNotEmpty){
                  Navigator.pop(context);
                  if(widget.stockItem == null){
                    await appBloc.createStock(StockItem(
                      name: name,
                      address: address
                    ));
                  }
                  else{
                    await appBloc.updateStock(StockItem(
                      name: name,
                      address: address
                    ), widget.stockItem!.key!);
                    await appBloc.callAccountingStreams();
                  }
                  await appBloc.callStocksStreams();
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
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
