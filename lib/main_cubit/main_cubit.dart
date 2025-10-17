// cubits/app/app_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/generated/l10n.dart';
import 'package:meko_project/models/enums/enums.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  void changeLanguage(TypeLanguage type) {
    Locale newLocale;

    switch (type) {
      case TypeLanguage.vi:
        newLocale = const Locale('vi', 'Vi');
        break;
      case TypeLanguage.en:
        newLocale = const Locale('en', 'En');
        break;
    }

    S.load(newLocale);
    emit(state.copyWith(locale: newLocale));
  }

  Locale get currentLocale => state.locale;
}