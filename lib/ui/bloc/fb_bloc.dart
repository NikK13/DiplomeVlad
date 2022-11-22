// ignore_for_file: use_build_context_synchronously
import 'package:auto_route/auto_route.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vlad_diplome/data/utils/constants.dart';
import 'package:vlad_diplome/data/utils/router.gr.dart';
import 'package:vlad_diplome/main.dart';
import 'package:vlad_diplome/ui/bloc/bloc.dart';
import 'package:vlad_diplome/ui/widgets/bottom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseBloc implements BaseBloc{
  late FirebaseAuth fbAuth;

  User? fbUser;

  String? username;
  String? image;

  bool emailValidated(email) => email.contains("@") && email.length >= 4;

  bool passwordValidated(password) => password.length >= 6;
  bool nameValidated(name) => name.length >= 2;

  FirebaseBloc() {
    load();
  }

  load() async {
    fbAuth = FirebaseAuth.instance;
    fbAuth.authStateChanges().listen((User? user) async {
      fbUser = user;
      if(user != null){
        isAsAdministrator = fbUser!.email!.contains(adminEmail);
        if(!isAsAdministrator){
          isUserEnabled = await userIsEnabled(fbUser!);
        }
        else{
          isUserEnabled = true;
        }
      }
    });
  }

  Future<void> signOutUser() async{
    isUserEnabled = false;
    await fbAuth.signOut();
  }

  Future<void> createAccount(context, name, surname, secondName, email, password, onSuccess) async {
    if(emailValidated(email) && passwordValidated(password)
        && nameValidated(name) && nameValidated(surname) && nameValidated(secondName)){
      isToRedirectHome = false;
      try {
        final UserCredential user = await fbAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if(user.user != null){
          await user.user!.sendEmailVerification();
          await createUserProfile(user.user!, name, surname, secondName, email, password);
          await fbAuth.signOut();
          Fluttertoast.showToast(
            msg: "Пользователь успешно создан. Для входа вам будет отправлено подтверждение на эл.почту"
          );
          onSuccess();
        }
      } on FirebaseAuthException catch (e) {
        showInfoDialog(context, e.message.toString());
      }
    }
    else{
      if(!emailValidated(email)){
        Fluttertoast.showToast(msg: "Эл.адрес должен содержать символ @ и состоять из 4 символов или более");
      }
      if(!nameValidated(name)){
        Fluttertoast.showToast(msg: "Имя должно содержать более одного символа");
      }
      if(!passwordValidated(email)){
        Fluttertoast.showToast(msg: "Пароль должен содержать более 5 символов");
      }
      if(!nameValidated(surname)){
        Fluttertoast.showToast(msg: "Фамилия должна содержать более одного символа");
      }
      if(!nameValidated(secondName)){
        Fluttertoast.showToast(msg: "Отчество должно содержать более одного символа");
      }
    }
  }

  Future<void> signIn(BuildContext context, email, password) async {
    try {
      isToRedirectHome = false;
      await fbAuth.signInWithEmailAndPassword(email: email, password: password);
      if(fbAuth.currentUser != null){
        if(fbAuth.currentUser!.email!.contains(adminEmail)){
          context.router.replaceAll([const HomePageRoute()]);
          isAsAdministrator = true;
          isToRedirectHome = true;
          isUserEnabled = true;
        }
        else{
          if(fbAuth.currentUser!.emailVerified){
            isUserEnabled = await userIsEnabled(fbAuth.currentUser!);
            isAsAdministrator = false;
            isToRedirectHome = true;
            context.router.replaceAll([const HomePageRoute()]);
          }
          else{
            Fluttertoast.showToast(msg: "Эл.адрес не подтвержден. Подтвердите перед входом в аккаунт");
            await fbAuth.signOut();
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  updateUserData({required Map<String, dynamic> data}) async {
    final db = FirebaseDatabase.instance.ref().child('employees/${fbAuth.currentUser!.uid}');
    await db.once().then((child) {
      db.child(fbAuth.currentUser!.uid).parent!.update(data);
    });
  }

  Future<bool> userIsEnabled(User user) async{
    final db = await FirebaseDatabase.instance.ref().child('employees/${user.uid}').once();
    return ((db.snapshot.value as Map)['is_activated']) as bool;
  }

  createUserProfile(user, name, surname, secondName, email, p) async {
    final db = FirebaseDatabase.instance.ref().child('employees/${user.uid}');
    await db.once().then((child) {
      if (!child.snapshot.exists) {
        db.child(user.uid).parent!.set(<String, dynamic>{
          "name": name,
          "surname": surname,
          "second_name": secondName,
          "email": email,
          "is_activated": false,
          //"hash": Encryption.generateHash(p),
        });
      }
    });
  }

  @override
  dispose() {}
}