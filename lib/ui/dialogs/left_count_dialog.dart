import 'package:flutter/material.dart';
import 'package:vlad_diplome/data/utils/lists.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/dropdown.dart';

class LeftCountDialog extends StatefulWidget {
  const LeftCountDialog({Key? key}) : super(key: key);

  @override
  State<LeftCountDialog> createState() => _LeftCountDialogState();
}

class _LeftCountDialogState extends State<LeftCountDialog> {
  late ListItem material;

  String? leftResult;

  List<ListItem> listMaterials = [];

  @override
  void initState() {
    for(var item in appBloc.materialsList){
      listMaterials.add(ListItem(item.name!, item.key!));
    }
    material = listMaterials.first;
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
            DropdownPicker(
              title: "Материал",
              myValue: material.value,
              items: listMaterials,
              darkColor: const Color(0xFF242424),
              onChange: (newVal){
                setState(() => material = listMaterials.firstWhere((element) => element.value == newVal));
              },
            ),
            const SizedBox(height: 16),
            AppButton(
              text: "Рассчитать остаток",
              onPressed: () {
                int count = appBloc.materialsList.firstWhere((element) => element.key == material.value).allCount!;
                for (var element in appBloc.accountingList) {
                  if(element.materialKey == material.value){
                    count -= element.count!;
                  }
                }
                setState(() {
                  leftResult = "Остаток: $count";
                });
              }
            ),
            const SizedBox(height: 16),
            if(leftResult != null)
            Text(
              leftResult!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
              ),
            )
          ],
        ),
      ),
    );
  }
}
