part of 'top_up_cubit.dart';

class TopUpState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final UserModel? user;
  final double? selectedAmount;
  final String? error;

  const TopUpState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.user,
    this.selectedAmount,
    this.error,
  });

  TopUpState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    UserModel? user,
    double? selectedAmount,
    String? error,
  }) {
    return TopUpState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      user: user ?? this.user,
      selectedAmount: selectedAmount ?? this.selectedAmount,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSubmitting, user, selectedAmount, error];
}
