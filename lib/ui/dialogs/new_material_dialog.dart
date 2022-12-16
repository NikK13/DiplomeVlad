import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vlad_diplome/data/model/material_item.dart';
import 'package:vlad_diplome/data/utils/lists.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/dropdown.dart';
import 'package:vlad_diplome/ui/widgets/input.dart';

class NewMaterialDialog extends StatefulWidget {
  final MaterialItem? materialItem;

  const NewMaterialDialog({Key? key, this.materialItem}) : super(key: key);

  @override
  State<NewMaterialDialog> createState() => _NewMaterialDialogState();
}

class _NewMaterialDialogState extends State<NewMaterialDialog> {
  late ListItem materialType;
  late ListItem vendorItem;
  List<ListItem> listItem = [];
  List<ListItem> listVendors = [];

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _countController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    for(var item in appBloc.materialsTypesList){
      listItem.add(ListItem(item.name!, item.key!));
    }
    for(var item in appBloc.vendorsList){
      listVendors.add(ListItem(item.name!, item.key!));
    }
    if(widget.materialItem == null){
      materialType = listItem.first;
      vendorItem = listVendors.first;
    }
    else{
      materialType = listItem.firstWhere((element) => element.value == widget.materialItem!.type!);
      vendorItem = listVendors.firstWhere((element) => element.value == widget.materialItem!.vendor!);

      _nameController.text = widget.materialItem!.name!;
      _descController.text = widget.materialItem!.desc!;
      _countController.text = widget.materialItem!.allCount!.toString();
      _priceController.text = widget.materialItem!.pricePerItem!.toString();
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
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: DropdownPicker(
                    title: "Вид материала",
                    myValue: materialType.value,
                    items: listItem,
                    darkColor: const Color(0xFF242424),
                    onChange: (newVal){
                      setState(() => materialType = listItem.firstWhere((element) => element.value == newVal));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:  DropdownPicker(
                    title: "Поставщик",
                    myValue: vendorItem.value,
                    items: listVendors,
                    darkColor: const Color(0xFF242424),
                    onChange: (newVal){
                      setState(() => vendorItem = listVendors.firstWhere((element) => element.value == newVal));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: InputField(
                    isEnabled: widget.materialItem == null,
                    hint: "Количество",
                    controller: _countController,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InputField(
                    hint: "Цена за единицу",
                    controller: _priceController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            InputField(
              hint: "Описание",
              controller: _descController,
            ),
            const SizedBox(height: 16),
            AppButton(
              text: widget.materialItem == null ?
              "Добавить" : "Сохранить",
              onPressed: () async{
                final name = _nameController.text.trim();
                final desc = _descController.text.trim();
                final price = _priceController.text.trim();
                final count = _countController.text.trim();
                if(name.isNotEmpty && price.isNotEmpty && count.isNotEmpty){
                  Navigator.pop(context);
                  final item = MaterialItem(
                    name: name,
                    vendor: vendorItem.value,
                    desc: desc,
                    type: materialType.value,
                    allCount: int.tryParse(count) ?? 0,
                    pricePerItem: double.tryParse(price) ?? 0.0
                  );
                  if(widget.materialItem == null){
                    await appBloc.createMaterial(item);
                  }
                  else{
                    await appBloc.updateMaterial(item, widget.materialItem!.key!);
                  }
                  await appBloc.callMaterialsStream();
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
    _priceController.dispose();
    _nameController.dispose();
    _countController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
