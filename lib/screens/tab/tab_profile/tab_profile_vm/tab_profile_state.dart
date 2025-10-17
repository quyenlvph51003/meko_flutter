import 'package:flutter/material.dart';

class AccountState {
  final String name;
  final int followers;
  final int following;
  final int coins;
  final bool headerReady;
  final bool retrying;

  AccountState({
    required this.name,
    required this.followers,
    required this.following,
    required this.coins,
    required this.headerReady,
    required this.retrying,
  });

  factory AccountState.initial() {
    return AccountState(
      name: 'Trần Dương PH 5 0 7 4 8',
      followers: 0,
      following: 0,
      coins: 0,
      headerReady: false,
      retrying: false,
    );
  }

  AccountState copyWith({
    String? name,
    int? followers,
    int? following,
    int? coins,
    bool? headerReady,
    bool? retrying,
  }) {
    return AccountState(
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      coins: coins ?? this.coins,
      headerReady: headerReady ?? this.headerReady,
      retrying: retrying ?? this.retrying,
    );
  }
}
