// screens/login_page/login_vm/login_state.dart
import 'package:flutter/material.dart';

class LoginState {
  final TextEditingController usernameCtrl;
  final TextEditingController passwordCtrl;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  LoginState({
    required this.usernameCtrl,
    required this.passwordCtrl,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return LoginState(
      usernameCtrl: usernameCtrl,
      passwordCtrl: passwordCtrl,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}