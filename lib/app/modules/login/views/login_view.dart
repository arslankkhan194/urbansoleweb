import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(16),
            width: 400,
            height: 400,
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Text(
                    "Login",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(hintText: "Email"),
                    validator: (val)=>GetUtils.isEmail(val!)?null:"Please enter valid Email Address",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: controller.passwordController,
                    decoration: InputDecoration(hintText: "Password"),
                    obscureText: true,
                    validator: (val)=>GetUtils.isLengthLessThan(val!, 6)?"Password must be greater than or equal to 6 characters":null
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(onPressed: () {controller.login();}, child: Text("Login"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
