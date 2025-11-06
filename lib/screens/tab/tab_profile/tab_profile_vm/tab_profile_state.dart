import 'package:meko_project/models/body/user/user_model.dart';
import 'package:equatable/equatable.dart';

class TabProfileState extends Equatable {
  final String name;
  final int followers;
  final int following;
  final int coins;
  final bool headerReady;
  final bool retrying;
  final UserModel user;

  TabProfileState({
    required this.name,
    required this.followers,
    required this.following,
    required this.coins,
    required this.headerReady,
    required this.retrying,
    required this.user,
  });

  factory TabProfileState.initial() {
    return TabProfileState(name: 'Vương Toàn Quyền', followers: 0, following: 0, coins: 0, headerReady: false, retrying: false, user: UserModel());
  }

  TabProfileState copyWith({String? name, int? followers, int? following, int? coins, bool? headerReady, bool? retrying, UserModel? user}) {
    return TabProfileState(
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      coins: coins ?? this.coins,
      headerReady: headerReady ?? this.headerReady,
      retrying: retrying ?? this.retrying,
      user: user ?? this.user,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name, followers, following, coins, headerReady, retrying, user];
}
