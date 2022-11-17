import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vlad_diplome/data/model/menu.dart';
import 'package:vlad_diplome/data/utils/app.dart';
import 'package:vlad_diplome/data/utils/extensions.dart';
import 'package:vlad_diplome/data/utils/router.gr.dart';
import 'package:vlad_diplome/data/utils/styles.dart';
import 'package:vlad_diplome/main.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 32, left: 24, right: 24
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      App.appName,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  Row(
                    children: [
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
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: !_isLoading ?
                isUserEnabled! ? Column(
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
                ) :  const Center(
                  child: Text(
                    "У вас нет прав\nПодождите пока вас рассмотрит администратор",
                    style: TextStyle(
                        fontSize: 14
                    ),
                    textAlign: TextAlign.center,
                  ),
                ) : const LoadingView(),
              )
            ],
          )
        ),
      ),
    );
  }
}