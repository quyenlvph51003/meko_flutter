class Sessions {
  Sessions._();

  static Sessions? _instance;

  static Sessions get instance {
    return _instance ??= Sessions._();
  }

  String? codeVerifier;

  String? codeChallenge;

  String? masterAccount;
}
