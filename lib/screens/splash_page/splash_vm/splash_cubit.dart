import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/screens/intro_page/intro_page.dart';
import 'package:meko_project/screens/splash_page/splash_vm/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState(showContent: false));

  void init(BuildContext context) async {
    updateAnimation();
    Future.delayed(const Duration(milliseconds: 1500), () async {
      bool? check = await SharedPref.instance.getBool(AppConsts.keyIntro);

      if(check == true){
        Navigator.pushReplacementNamed(context, RouterPaths.homePage);
      }else{
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return IntroPage();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 150),
          ),
        );
      }
    });
  }

  void updateAnimation() {
    emit(state.copyWith(showContent: true));
  }
}