import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vlad_diplome/data/model/material_item.dart';
import 'package:vlad_diplome/data/model/material_types.dart';
import 'package:vlad_diplome/data/model/menu.dart';
import 'package:vlad_diplome/data/utils/app.dart';
import 'package:vlad_diplome/data/utils/extensions.dart';
import 'package:vlad_diplome/data/utils/router.gr.dart';
import 'package:vlad_diplome/data/utils/styles.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/widgets/button.dart';
import 'package:vlad_diplome/ui/widgets/loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    if(isAsAdministrator) setState(() => _isLoading = false);
    firebaseBloc.fbAuth.authStateChanges().listen((User? user) async{
      if(user != null){
        if(!isAsAdministrator){
          isUserEnabled = await firebaseBloc.userIsEnabled(user);
          if(!mounted) return;
          setState(() => _isLoading = false);
        }
        else{
          isUserEnabled = true;
        }
      }
    });
    appBloc.callMaterialsTypesStreams();
    appBloc.callVendorsStreams();
    appBloc.callMaterialsStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  /*borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24)
                  )*/
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            App.appName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.black
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            if(isAsAdministrator)
                            IconButton(
                              onPressed: (){
                                context.router.push(const EmployeesPageRoute());
                              },
                              icon: const Icon(
                                Icons.person_search_outlined,
                                size: 32,
                                color: appColor
                              ),
                              tooltip: "Сотрудники",
                            ),
                            /*IconButton(
                              onPressed: (){

                              },
                              icon: const Icon(
                                Icons.info_outlined,
                                size: 32,
                                color: appColor
                              )
                            ),*/
                            const SizedBox(width: 2),
                            IconButton(
                              icon: const Icon(
                                Icons.logout,
                                size: 32,
                              ),
                              color: appColor,
                              onPressed: () async{
                                await firebaseBloc.signOutUser();
                                loadingFuture = Future.value(true);
                                context.router.replaceAll([const LoginPageRoute()]);
                              },
                              tooltip: "Выйти из профиля",
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: (){

                              },
                              child: const Text(
                                "Учет материалов",
                                style: TextStyle(
                                  color: appColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                context.router.push(const MaterialsTypesListPageRoute());
                              },
                              child: const Text(
                                "Виды материалов",
                                style: TextStyle(
                                  color: appColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                if(appBloc.materialsTypesList.isNotEmpty &&
                                appBloc.vendorsList.isNotEmpty){
                                  context.router.push(const MaterialsListPageRoute());
                                }
                                else{
                                  Fluttertoast.showToast(msg: "Для добавления материалов должен быть "
                                      "добавлен хотя бы один поставщик и один вид материала");
                                }
                              },
                              child: const Text(
                                "Материалы",
                                style: TextStyle(
                                  color: appColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                context.router.push(const VendorsListPageRoute());
                              },
                              child: const Text(
                                "Поставщики",
                                style: TextStyle(
                                  color: appColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                context.router.push(const StocksListPageRoute());
                              },
                              child: const Text(
                                "Склады",
                                style: TextStyle(
                                  color: appColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16)
                  ],
                ),
              ),
              !_isLoading ?
              isUserEnabled! ? const HomePageContent()/*Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    " Меню",
                    style: TextStyle(
                      fontSize: 22
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCountOnWidth(context),
                        mainAxisSpacing: 8, crossAxisSpacing: 8,
                        childAspectRatio: 1.5
                      ),
                      itemCount: SingleMenu.menuList(context).length,
                      itemBuilder: (context, index){
                        return MenuWidget(menu: SingleMenu.menuList(context)[index]);
                      }
                    ),
                  ),
                ],
              )*/ :  const Center(
                child: Text(
                  "У вас нет прав\nПодождите пока вас рассмотрит администратор",
                  style: TextStyle(
                    fontSize: 14
                  ),
                  textAlign: TextAlign.center,
                ),
              ) : const LoadingView()
            ],
          ),
        ),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/sklad.jpg",
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Column(
          children: const [
            SizedBox(height: 16),
            Text(
              "Контакты:",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "+375 29 121 21 21",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "+375 29 222 33 66",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "2022 год",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 16),
          ],
        )
      ],
    );
  }
}


class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: App.appPadding,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width > 400 ?
              400 : MediaQuery.of(context).size.width,
              child: AppButton(
                text: "Войти в учет",
                onPressed: (){

                },
              ),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                const Text(
                  "Виды материалов",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700
                  ),
                ),
                InkWell(
                  onTap: (){
                    context.router.push(const MaterialsTypesListPageRoute());
                  },
                  child: const Text(
                    "Посмотреть все",
                    style: TextStyle(
                      fontSize: 12,
                      color: appColor,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            StreamBuilder(
              stream: appBloc.materialsTypesStream,
              builder: (context, AsyncSnapshot<List<MaterialsTypes>?> snapshot){
                if(snapshot.hasData){
                  if(snapshot.data!.isNotEmpty){
                    return materialTypesTable(snapshot.data!);
                  }
                  return const Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Center(child: Text("Пока здесь пусто")),
                  );
                }
                return const LoadingView();
              },
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Материалы",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700
                  ),
                ),
                InkWell(
                  onTap: (){
                    context.router.push(const MaterialsListPageRoute());
                  },
                  child: const Text(
                    "Посмотреть все",
                    style: TextStyle(
                      fontSize: 12,
                      color: appColor,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            StreamBuilder(
              stream: appBloc.materialsStream,
              builder: (context, AsyncSnapshot<List<MaterialItem>?> snapshot){
                if(snapshot.hasData){
                  if(snapshot.data!.isNotEmpty){
                    return materialsTable(snapshot.data!);
                  }
                  return const Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Center(child: Text("Пока здесь пусто")),
                  );
                }
                return const LoadingView();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget materialTypesTable(List<MaterialsTypes> types, {int length = 3}) {
    return Table(
      border: TableBorder.all(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade800,
        width: 1.5
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(6),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: types.getRange(0, types.length > length
          ? length : types.length).toList().asMap().map((index, item){
        return MapEntry(index, TableRow(children: [
          tableCell((index + 1).toString(), isTitle: true),
          tableCell(item.name!, isTitle: true),
        ]));
      }).values.toList()..insert(0, TableRow(children: [
        tableCell("ID", isTitle: true),
        tableCell("Наименование", isTitle: true)
      ])),
    );
  }

  Widget materialsTable(List<MaterialItem> types, {int length = 3}) {
    return Table(
      border: TableBorder.all(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade800,
        width: 1.5
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(3),
        3: FlexColumnWidth(2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: types.getRange(0, types.length > length
          ? length : types.length).toList().asMap().map((index, item){
        return MapEntry(index, TableRow(children: [
          tableCell((index + 1).toString(), isTitle: true),
          tableCell(item.name!),
          tableCell(
            appBloc.materialsTypesList.
            firstWhere((element) => element.key == item.type!).name!,
          ),
          tableCell(item.vendor!),
        ]));
      }).values.toList()..insert(0, TableRow(children: [
        tableCell("ID", isTitle: true),
        tableCell("Название", isTitle: true),
        tableCell("Вид материала", isTitle: true),
        tableCell("Поставщик", isTitle: true),
      ])),
    );
  }
}
