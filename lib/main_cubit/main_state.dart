import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MainState extends Equatable {
  final Locale locale;

  const MainState({
    this.locale = const Locale('vi', ''),
  });

  MainState copyWith({
    Locale? locale,
  }) {
    return MainState(
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [locale];
}