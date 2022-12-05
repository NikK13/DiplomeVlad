import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vlad_diplome/data/model/vendor.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/input.dart';

class NewVendorDialog extends StatefulWidget {
  const NewVendorDialog({Key? key}) : super(key: key);

  @override
  State<NewVendorDialog> createState() => _NewVendorDialogState();
}

class _NewVendorDialogState extends State<NewVendorDialog> {
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
                  await appBloc.createVendor(VendorItem(
                    name: name
                  ));
                  await appBloc.callVendorsStreams();
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
