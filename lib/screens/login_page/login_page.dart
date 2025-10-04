import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meko_project/consts/app_images.dart';

import 'login_vm.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  LoginVm vm = Get.put<LoginVm>(LoginVm());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    vm.dispose();
    Get.delete<LoginVm>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Container(
                width: Get.width,
                height: Get.height,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(height: 150),
                      Image.asset(
                        AppImages.img_splash,
                        height: 170,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(height: 4),

                      const SizedBox(height: 24),
                      // AppEditText(controller: vm.usernameCtrl),
                      const SizedBox(height: 16),
                      // AppEditText(controller: vm.passwordCtrl),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
