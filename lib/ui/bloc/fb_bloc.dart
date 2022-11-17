// ignore_for_file: use_build_context_synchronously
import 'package:auto_route/auto_route.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vlad_diplome/data/utils/constants.dart';
import 'package:vlad_diplome/data/utils/encrypt.dart';
import 'package:vlad_diplome/data/utils/localization.dart';
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
          Fluttertoast.showToast(msg: AppLocalizations.of(context, 'sign_up_success'));
          onSuccess();
        }
      } on FirebaseAuthException catch (e) {
        showInfoDialog(context, e.message.toString());
      }
    }
    else{
      if(!emailValidated(email)){
        Fluttertoast.showToast(msg: AppLocalizations.of(context, 'error_email'));
      }
      if(!nameValidated(name)){
        Fluttertoast.showToast(msg: AppLocalizations.of(context, 'error_name'));
      }
      if(!nameValidated(surname)){
        Fluttertoast.showToast(msg: AppLocalizations.of(context, 'error_surname'));
      }
      if(!nameValidated(secondName)){
        Fluttertoast.showToast(msg: AppLocalizations.of(context, 'error_second_name'));
      }
      if(!passwordValidated(email)){
        Fluttertoast.showToast(msg: AppLocalizations.of(context, 'error_password'));
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
            Fluttertoast.showToast(msg: AppLocalizations.of(context, 'login_verify'));
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
          "hash": Encryption.generateHash(p),
        });
      }
    });
  }

  @override
  dispose() {}
}