import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/screens/splash_page/splash_vm.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  SplashVm vm = Get.put<SplashVm>(SplashVm());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      vm.updateBrg();
      vm.init();
    });
  }

  @override
  void dispose() {
    vm.dispose();
    Get.delete<SplashVm>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F6FF),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              valueListenable: vm.flagOpacity,
              builder: (context, bool check, child) {
                return AnimatedOpacity(
                  duration: Duration(milliseconds: 800),
                  opacity: check ? 1 : 0,
                  child: Image.asset(
                    AppImages.img_splash,
                    height: 125,
                    fit: BoxFit.fitHeight,
                  ),
                );
              },
            ),
            SizedBox(height: 4),
            //  nameApp(),
            SizedBox(height: 24),
            SizedBox(
              width: Get.width * 0.5,
              height: 2.5,
              child: Stack(
                children: [
                  Container(
                    width: Get.width,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: Color(0xFFE6EBF8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: vm.flagOpacity,
                    builder: (context, bool check, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 1800),
                        width: check ? Get.width : 0,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF2D2E),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: Get.width * 0.28),
          ],
        ),
      ),
    );
  }
}
