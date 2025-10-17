part of 'home_cubit.dart';

class HomeState extends Equatable {
   bool shouldShowPostSheet;
   bool isLoggedIn;

   HomeState({this.shouldShowPostSheet = false, this.isLoggedIn = false});

  HomeState copyWith({bool? shouldShowPostSheet, bool? isLoggedIn}) {
    return HomeState(
      shouldShowPostSheet: shouldShowPostSheet ?? this.shouldShowPostSheet,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  @override
  List<Object?> get props => [shouldShowPostSheet, isLoggedIn];
}
