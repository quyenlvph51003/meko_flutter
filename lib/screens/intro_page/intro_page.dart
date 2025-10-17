import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/widget/app_button/app_button.dart';

import 'intro_vm/intro_cubit.dart';
import 'intro_vm/intro_state.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => IntroCubit(), child: const IntroPageView());
  }
}

class IntroPageView extends StatelessWidget {
  const IntroPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<IntroCubit>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          const SizedBox(height: 32),
          Expanded(
            child: PageView(
              pageSnapping: true,
              padEnds: false,
              allowImplicitScrolling: false,
              controller: cubit.state.pageController,
              onPageChanged: cubit.onPageChanged,
              children: [
                buildOnboard(
                  'Mua bán đồ cũ dễ dàng',
                  'Khám phá hàng ngàn sản phẩm đã qua sử dụng\nchất lượng với giá tốt nhất. Tiết kiệm và thân thiện\nvới môi trường.',
                ),
                buildOnboard(
                  'Giao dịch an toàn & tin cậy',
                  'Hệ thống xác thực người dùng và đánh giá uy tín\ngiúp bạn mua bán yên tâm. Mọi giao dịch đều được\nbảo vệ.',
                ),
                buildOnboard(
                  'Đăng tin nhanh chóng',
                  'Chụp ảnh, mô tả và đăng tin chỉ trong vài phút.\nTiếp cận hàng nghìn người mua tiềm năng ngay\nlập tức.',
                ),
              ],
            ),
          ),
          BlocBuilder<IntroCubit, IntroState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: AnimatedContainer(
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 450),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: state.currentIndex == i ? AppColor.white : AppColor.cGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 24),
          buildButton(cubit, screenWidth),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  BlocBuilder<IntroCubit, IntroState> buildButton(IntroCubit cubit, double screenWidth) {
    return BlocBuilder<IntroCubit, IntroState>(
      builder: (context, state) {
        return AppButton(
          onTap: (){
            return cubit.nextTap(context);
          },
          child: Container(
            height: 60,
            width: screenWidth,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColor.color34,
            ),
            child: Center(
              child: Text(
                cubit.getTitleBtn(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildOnboard(String title, String subtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 44),
        buildHeader(AppImages.img_magic_brush, 'Meko', 'Bỏ qua'),
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColor.cGreen70,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget buildHeader(String images, String title, String action) {
    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        return Container(
          width: screenWidth * 0.9,
          height: 408,
          margin: const EdgeInsets.only(right: 16, left: 16),
          decoration: BoxDecoration(
            color: AppColor.cGreen70,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 120,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
