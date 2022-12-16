import 'package:flutter/material.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Заведующий склада №1:"),
            const SizedBox(height: 4),
            const Text("Забелин Андрей Геннадьевич"),
            const SizedBox(height: 4),
            const Text("Телефон: +375 29 111 22 33"),
            const SizedBox(height: 24),
            const Text("Заведующий склада №2:"),
            const SizedBox(height: 4),
            const Text("Викторенко Павел Борисович"),
            const SizedBox(height: 4),
            const Text("Телефон: +375 29 222 33 44"),
            const SizedBox(height: 16),
            AppButton(
              text: "Понятно",
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
