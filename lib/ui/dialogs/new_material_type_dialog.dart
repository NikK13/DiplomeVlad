import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vlad_diplome/data/model/material_types.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/input.dart';

class NewMaterialTypeDialog extends StatefulWidget {
  final MaterialsTypes? materialsType;

  const NewMaterialTypeDialog({Key? key, this.materialsType}) : super(key: key);

  @override
  State<NewMaterialTypeDialog> createState() => _NewMaterialTypeDialogState();
}

class _NewMaterialTypeDialogState extends State<NewMaterialTypeDialog> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    if(widget.materialsType != null){
      _nameController.text = widget.materialsType!.name!;
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
            AppButton(
                text: widget.materialsType == null ?
                "Добавить" : "Сохранить",
                onPressed: () async{
                  final name = _nameController.text.trim();
                  if(name.isNotEmpty){
                    Navigator.pop(context);
                    if(widget.materialsType == null){
                      await appBloc.createMaterialsType(name);
                    }
                    else{
                      await appBloc.updateMaterialsType(MaterialsTypes(
                        name: name
                      ), widget.materialsType!.key!);
                    }
                    await appBloc.callMaterialsTypesStreams();
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
    super.dispose();
  }
}
