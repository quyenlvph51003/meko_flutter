part of 'home_cubit.dart';

class HomeState extends Equatable {
  final bool shouldShowPostSheet;
  final bool isLoggedIn;
  final int currentIndex;
  final int uiRev;

  const HomeState({
    this.shouldShowPostSheet = false,
    this.isLoggedIn = false,
    this.currentIndex = 0,
    this.uiRev = 0,
  });

  HomeState copyWith({
    bool? shouldShowPostSheet,
    bool? isLoggedIn,
    int? currentIndex,
    int? uiRev,
  }) {
    return HomeState(
      shouldShowPostSheet: shouldShowPostSheet ?? this.shouldShowPostSheet,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      currentIndex: currentIndex ?? this.currentIndex,
      uiRev: uiRev ?? this.uiRev,
    );
  }

  @override
  List<Object?> get props => [shouldShowPostSheet, isLoggedIn, currentIndex, uiRev];
}
