part of 'packages_cubit.dart';

class PackagesState extends Equatable {
  final List<UserPaymentModel> userPayments;
  final List<PackageModel> packages;
  final bool isLoading;
  final int selectedIndex;
  // Constructor
  const PackagesState({
    this.userPayments = const [],
    this.packages = const [],
    this.isLoading = false,
    this.selectedIndex=0
  });

  // copyWith
  PackagesState copyWith({
    List<UserPaymentModel>? userPayments,
    List<PackageModel>? packages,
    bool? isLoading,
    final int? selectedIndex
  }) {
    return PackagesState(
      userPayments: userPayments ?? this.userPayments,
      packages: packages ?? this.packages,
      isLoading: isLoading ?? this.isLoading,
      selectedIndex: selectedIndex ?? this.selectedIndex
    );
  }

  @override
  List<Object?> get props => [userPayments, packages, isLoading,selectedIndex];
}
