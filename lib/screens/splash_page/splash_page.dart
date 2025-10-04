import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/screens/splash_page/splash_vm/splash_cubit.dart';
import 'package:meko_project/screens/splash_page/splash_vm/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(),
      child: const SplashPageView(),
    );
  }
}

class SplashPageView extends StatefulWidget {
  const SplashPageView({Key? key}) : super(key: key);

  @override
  State<SplashPageView> createState() => _SplashPageViewState();
}

class _SplashPageViewState extends State<SplashPageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<SplashCubit, SplashState>(
              builder: (context, state) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: state.showContent ? 1 : 0,
                  child: Image.asset(
                    AppImages.img_splash,
                    height: 125,
                    fit: BoxFit.fitHeight,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            const SizedBox(height: 24),
            SizedBox(
              width: screenWidth * 0.5,
              height: 2.5,
              child: Stack(
                children: [
                  Container(
                    width: screenWidth,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6EBF8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  BlocBuilder<SplashCubit, SplashState>(
                    builder: (context, state) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 1800),
                        width: state.showContent ? screenWidth : 0,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF2D2E),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: screenWidth * 0.28),
          ],
        ),
      ),
    );
  }
}