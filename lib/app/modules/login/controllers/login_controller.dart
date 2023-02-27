import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:urban_sound_art_admin/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
  }

  login() {
    if (formKey.currentState!.validate()) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) => Get.offAllNamed(Routes.HOME))
          .catchError((onError) => print("$onError"));
    }
  }
}
