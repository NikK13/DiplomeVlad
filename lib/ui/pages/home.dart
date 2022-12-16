import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vlad_diplome/data/utils/app.dart';
import 'package:vlad_diplome/data/utils/extensions.dart';
import 'package:vlad_diplome/data/utils/router.gr.dart';
import 'package:vlad_diplome/data/utils/styles.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/dialogs/info_dialog.dart';
import 'package:vlad_diplome/ui/pages/materials.dart';
import 'package:vlad_diplome/ui/pages/materials_accounting.dart';
import 'package:vlad_diplome/ui/pages/materials_types.dart';
import 'package:vlad_diplome/ui/pages/stocks.dart';
import 'package:vlad_diplome/ui/pages/vendors.dart';
import 'package:vlad_diplome/ui/widgets/loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  int _selectedIndex = 0;

  @override
  void initState() {
    if(isAsAdministrator) setState(() => _isLoading = false);
    appBloc.callVendorsStreams();
    appBloc.callMaterialsTypesStreams();
    appBloc.callMaterialsStream();
    appBloc.callEmployeesStream();
    appBloc.callStocksStreams();
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: InkWell(
                          onTap: (){
                            setState(() => _selectedIndex = 0);
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/logo.jpg",
                                width: 50, height: 50,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                App.appName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black
                                ),
                              ),
                            ],
                          )
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
                          IconButton(
                            onPressed: (){
                              showCustomDialog(context, const InfoDialog());
                            },
                            icon: const Icon(
                              Icons.info_outlined,
                              size: 32,
                              color: appColor
                            )
                          ),
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
                        mainButton(0, "Главная"),
                        const SizedBox(width: 20),
                        mainButton(1, "Учет материалов"),
                        const SizedBox(width: 20),
                        mainButton(2, "Виды материалов"),
                        const SizedBox(width: 20),
                        mainButton(3, "Материалы"),
                        const SizedBox(width: 20),
                        mainButton(4, "Поставщики"),
                        const SizedBox(width: 20),
                        mainButton(5, "Склады"),
                        /*Expanded(
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
                        ),*/
                      ],
                    ),
                  ),
                  const SizedBox(height: 16)
                ],
              ),
            ),
            !_isLoading ?
            isUserEnabled! ? Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: const [
                  HomePageContent(),
                  MaterialsAccountingPage(),
                  MaterialsTypesListPage(),
                  MaterialsListPage(),
                  VendorsListPage(),
                  StocksListPage()
                ],
              ),
            ) : const Center(
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
    );
  }

  Widget mainButton(int index, String text) => Expanded(
    child: InkWell(
      onTap: (){
        if(index == 3){
          if(appBloc.materialsTypesList.isNotEmpty && appBloc.vendorsList.isNotEmpty){
            setState(() => _selectedIndex = index);
          }
          else{
            Fluttertoast.showToast(msg: "Для добавления материалов должен быть "
            "добавлен хотя бы один поставщик и один вид материала");
          }
        }
        else if(index == 1){
          if(appBloc.materialsList.isNotEmpty){
            setState(() => _selectedIndex = index);
          }
          else{
            Fluttertoast.showToast(msg: "Для добавления в учет должен быть "
            "добавлен хотя бы один материал");
          }
        }
        else{
          setState(() => _selectedIndex = index);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: appColor,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Container(
            width: 50, height: 3.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: _selectedIndex == index ?
              appColor : Colors.white
            ),
          )
        ],
      ),
    ),
  );
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                child: Image.asset(
                  "assets/sklad.jpg",
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black.withOpacity(0.55),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              const Positioned.fill(
                child: Center(
                  child: Text(
                    "Все что делается\n-\nделается только для вас",
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          /*Column(
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
          )*/
        ],
      ),
    );
  }
}
