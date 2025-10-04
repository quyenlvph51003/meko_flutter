import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/screens/intro_page/intro_page_vm.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  IntroPageVm vm = Get.put<IntroPageVm>(IntroPageVm());
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          SizedBox(height: 32),
          Expanded(
            child: PageView(
              pageSnapping: true,
              padEnds: false,
              allowImplicitScrolling: false,
              controller: vm.pageCtrl,
              onPageChanged: (i) {},
              children: [
                buildOnboard(
                  'Explore a wide range of products',
                  'Explore a wide range of products at your fingertips.QuickMart offers an extensive \n'
                      'collection to suit your needs.',
                ),
                buildOnboard(
                  'Unlock exclusive offers and discounts',
                  'Get access to limited-time deals and special\n'
                      ' promotions available only to our valued \n customers.',
                ),
                buildOnboard(
                  'Safe and secure \n payments',
                  'QuickMart employs industry-leading encryption \n '
                      'and trusted payment gateways to safeguard your\n '
                      ' financial information.',
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: AnimatedContainer(
                    curve: Curves.easeIn,
                    duration: Duration(milliseconds: 450),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index == i ?  AppColor.cGreen70: AppColor.cGray70,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Container(
            height: 60,
            child: GestureDetector(
              onTap: () {
                vm.nextTap();
                // }
              },
              child: Container(
                height: 60,
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(
                    vm.getTitleBtn(1),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColor.cGreen70,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget buildOnboard(String title, String subtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 44),
        buildHeader(
          AppImages.img_magic_brush,
          'QuickMart',
          'Skip for now',
        ),
        SizedBox(height: 24),
        Text(
          '$title',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColor.cGreen70,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          '$subtitle',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        //buildButtonNextPage(),
      ],
    );
  }

  Widget buildHeader(String images, String title, String action) {
    return Container(
      width: Get.width * 0.9,
      height: 408,
      margin: EdgeInsets.only(right: 16, left: 16),
      decoration: BoxDecoration(
        color: AppColor.cGreen70,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [],
      ),
    );
  }
}
