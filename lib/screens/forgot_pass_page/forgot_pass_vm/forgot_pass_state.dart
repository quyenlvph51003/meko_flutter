import 'package:equatable/equatable.dart';

class ForgotPassState extends Equatable {
   String email;
   bool loading;
   bool sent;
   String? errorMessage;
   String otp;
   bool verified;

   ForgotPassState({
    this.email = '',
    this.loading = false,
    this.sent = false,
    this.errorMessage,
    this.otp = '',
    this.verified = false,
  });

  ForgotPassState copyWith({
    String? email,
    bool? loading,
    bool? sent,
    String? errorMessage,
    String? otp,
    bool? verified,
  }) {
    return ForgotPassState(
      email: email ?? this.email,
      loading: loading ?? this.loading,
      sent: sent ?? this.sent,
      errorMessage: errorMessage,
      otp: otp ?? this.otp,
      verified: verified ?? this.verified,
    );
  }

  factory ForgotPassState.initial() =>  ForgotPassState();

  @override
  List<Object?> get props => [email, loading, sent, errorMessage, otp, verified];
}
