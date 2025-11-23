part of 'purcharse_create_post_cubit.dart';

class PurcharseCreatePostState extends Equatable {
  final bool isLoading;
  final List<UserPaymentModel> userPayments;

  const PurcharseCreatePostState({this.isLoading = false, this.userPayments = const []});

  PurcharseCreatePostState copyWith({bool? isLoading, List<UserPaymentModel>? userPayments}) {
    return PurcharseCreatePostState(isLoading: isLoading ?? this.isLoading, userPayments: userPayments ?? this.userPayments);
  }

  @override
  List<Object?> get props => [isLoading, userPayments];
}
