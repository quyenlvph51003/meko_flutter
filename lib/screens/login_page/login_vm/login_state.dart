import 'package:flutter/material.dart';

class LoginState {
  final TextEditingController usernameCtrl;
  final TextEditingController passwordCtrl;
  final bool isLoading;
  final String? errorMessage;

  LoginState({
    required this.usernameCtrl,
    required this.passwordCtrl,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginState(
      usernameCtrl: usernameCtrl,
      passwordCtrl: passwordCtrl,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
