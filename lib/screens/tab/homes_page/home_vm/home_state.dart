part of 'home_cubit.dart';

class HomeState extends Equatable {
  final bool shouldShowPostSheet;
  final bool isLoggedIn;
  final int currentIndex;
  final int uiRev;
  final bool? isCheckShowAuth;

  const HomeState({
    this.shouldShowPostSheet = false,
    this.isLoggedIn = false,
    this.currentIndex = 0,
    this.uiRev = 0,
    this.isCheckShowAuth,
  });

  HomeState copyWith({
    bool? shouldShowPostSheet,
    bool? isLoggedIn,
    int? currentIndex,
    int? uiRev,
    bool? isCheckShowAuth,
  }) {
    return HomeState(
      shouldShowPostSheet: shouldShowPostSheet ?? this.shouldShowPostSheet,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      currentIndex: currentIndex ?? this.currentIndex,
      uiRev: uiRev ?? this.uiRev,
      isCheckShowAuth: isCheckShowAuth ?? this.isCheckShowAuth,
    );
  }

  @override
  List<Object?> get props => [
    shouldShowPostSheet,
    isLoggedIn,
    currentIndex,
    uiRev,
    isCheckShowAuth,
  ];
}
