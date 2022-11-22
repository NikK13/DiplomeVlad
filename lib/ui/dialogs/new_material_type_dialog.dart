import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vlad_diplome/data/model/employee.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/input.dart';

class NewMaterialTypeDialog extends StatefulWidget {
  const NewMaterialTypeDialog({Key? key}) : super(key: key);

  @override
  State<NewMaterialTypeDialog> createState() => _NewMaterialTypeDialogState();
}

class _NewMaterialTypeDialogState extends State<NewMaterialTypeDialog> {
  final _nameController = TextEditingController();

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
                text: "Добавить",
                onPressed: () async{
                  final name = _nameController.text.trim();
                  if(name.isNotEmpty){
                    Navigator.pop(context);
                    await appBloc.createMaterialsType(name);
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
