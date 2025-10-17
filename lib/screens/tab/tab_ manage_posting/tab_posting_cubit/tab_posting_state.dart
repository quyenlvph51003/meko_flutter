import 'package:equatable/equatable.dart';

class TabPostingState extends Equatable {
  bool? isLoggedIn;

  TabPostingState({this.isLoggedIn = false});

  TabPostingState copyWith({bool? shouldShowPostSheet, bool? isLoggedIn}) {
    return TabPostingState(isLoggedIn: isLoggedIn ?? this.isLoggedIn);
  }

  @override
  List<Object?> get props => [];
}
