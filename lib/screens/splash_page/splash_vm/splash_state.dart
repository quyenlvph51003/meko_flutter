class SplashState {
  bool showContent;

  SplashState({required this.showContent});

  SplashState copyWith({bool? showContent}) {
    return SplashState(showContent: showContent ?? this.showContent);
  }
}
