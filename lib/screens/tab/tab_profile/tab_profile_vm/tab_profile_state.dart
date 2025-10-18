class TabProfileState {
  final String name;
  final int followers;
  final int following;
  final int coins;
  final bool headerReady;
  final bool retrying;

  TabProfileState({
    required this.name,
    required this.followers,
    required this.following,
    required this.coins,
    required this.headerReady,
    required this.retrying,
  });

  factory TabProfileState.initial() {
    return TabProfileState(
      name: 'Vương Toàn Quyền',
      followers: 0,
      following: 0,
      coins: 0,
      headerReady: false,
      retrying: false,
    );
  }

  TabProfileState copyWith({
    String? name,
    int? followers,
    int? following,
    int? coins,
    bool? headerReady,
    bool? retrying,
  }) {
    return TabProfileState(
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      coins: coins ?? this.coins,
      headerReady: headerReady ?? this.headerReady,
      retrying: retrying ?? this.retrying,
    );
  }
}
