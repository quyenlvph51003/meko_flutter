part of 'home_cubit.dart';

class HomeState extends Equatable {
  final bool shouldShowPostSheet;
  final bool isLoggedIn;
  final int currentIndex;

  const HomeState({
    this.shouldShowPostSheet = false,
    this.isLoggedIn = false,
    this.currentIndex = 0,
  });

  HomeState copyWith({
    bool? shouldShowPostSheet,
    bool? isLoggedIn,
    int? currentIndex,
  }) {
    return HomeState(
      shouldShowPostSheet: shouldShowPostSheet ?? this.shouldShowPostSheet,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [shouldShowPostSheet, isLoggedIn, currentIndex];
}
