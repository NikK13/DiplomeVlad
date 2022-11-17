import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vlad_diplome/data/utils/router.gr.dart';
import 'package:vlad_diplome/main.dart';

class SingleMenu{
  String? title;
  Function? onTap;

  SingleMenu({this.title, this.onTap});

  static List<SingleMenu> menuList(BuildContext context) => [
    if(isAsAdministrator)
    SingleMenu(
      title: "Сотрудники",
      onTap: (){
        context.router.push(const EmployeesPageRoute());
      }
    ),
    SingleMenu(
      title: "Учет\nматериалов",
      onTap: (){

      }
    ),
    SingleMenu(
      title: "Виды\nматериалов",
      onTap: (){
        context.router.push(const MaterialsTypesListPageRoute());
      }
    )
  ];
}

class MenuWidget extends StatelessWidget {
  final SingleMenu? menu;

  const MenuWidget({Key? key, this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      hoverColor: Colors.transparent,
      onTap: () => menu!.onTap!(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Center(
          child: Text(
            menu!.title!,
            style: const TextStyle(
              fontSize: 16
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
