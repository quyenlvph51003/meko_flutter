import 'package:flutter/material.dart';

class SignUpState {
  TextEditingController userName;
  TextEditingController emailCtrl;
  TextEditingController passwordCtrl;
  bool isLoading;
  bool isSuccess;
  String? message;
  bool acceptedTerms;

  SignUpState({
    required this.userName,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.isLoading,
    required this.isSuccess,
    required this.message,
    required this.acceptedTerms,
  });

  factory SignUpState.initial() => SignUpState(
    userName: TextEditingController(),
    emailCtrl: TextEditingController(),
    passwordCtrl: TextEditingController(),
    isLoading: false,
    isSuccess: false,
    message: null,
    acceptedTerms: false,
  );

  SignUpState copyWith({
    TextEditingController? fullNameCtrl,
    TextEditingController? emailCtrl,
    TextEditingController? passwordCtrl,
    TextEditingController? confirmCtrl,
    bool? isLoading,
    bool? isSuccess,
    String? message,
    bool? acceptedTerms,
  }) {
    return SignUpState(
      userName: fullNameCtrl ?? this.userName,
      emailCtrl: emailCtrl ?? this.emailCtrl,
      passwordCtrl: passwordCtrl ?? this.passwordCtrl,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
    );
  }
}
