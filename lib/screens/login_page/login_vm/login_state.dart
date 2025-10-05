import 'package:flutter/material.dart';

class LoginState {
  TextEditingController usernameCtrl;
  TextEditingController passwordCtrl;
  bool isLoading;
  String? errorMessage;

  LoginState({
    required this.usernameCtrl,
    required this.passwordCtrl,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({bool? isLoading, String? errorMessage}) {
    return LoginState(
      usernameCtrl: usernameCtrl,
      passwordCtrl: passwordCtrl,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
