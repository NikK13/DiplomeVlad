import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vlad_diplome/data/model/vendor.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/input.dart';

class NewVendorDialog extends StatefulWidget {
  final VendorItem? vendorItem;

  const NewVendorDialog({Key? key, this.vendorItem}) : super(key: key);

  @override
  State<NewVendorDialog> createState() => _NewVendorDialogState();
}

class _NewVendorDialogState extends State<NewVendorDialog> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    if(widget.vendorItem != null){
      _nameController.text = widget.vendorItem!.name!;
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
              text: widget.vendorItem == null ?
              "Добавить" : "Сохранить",
              onPressed: () async{
                final name = _nameController.text.trim();
                if(name.isNotEmpty){
                  Navigator.pop(context);
                  if(widget.vendorItem == null){
                    await appBloc.createVendor(VendorItem(
                      name: name
                    ));
                  }
                  else{
                    await appBloc.updateVendor(VendorItem(
                      name: name
                    ), widget.vendorItem!.key!);
                    appBloc.callMaterialsStream();
                  }
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
