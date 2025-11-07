class ApiPath {
  //auth
  static const String authRegister = 'auth/register';
  static const String authLogin = 'auth/login';
  static const String authRefresh = 'auth/refresh-token';
  static const String authRequestOtp = 'auth/request-otp';
  static const String authVerifyOtp = 'auth/verify-otp';
  static const String categoryList = 'category/list';
  static const String searchPost = 'post/search-post';
  static const String postDetail = 'post/detail/';

  //user
  static const String getProfile = 'user/profile';

  //province
  static const String getAllProvince = 'province/get-all';
  //ward
  static const String getWards = 'ward/get-by-province-code';

  //favorite
  static const String createFavorite = 'favorite/create';
  static const String deleteFavorite = 'favorite/delete/';
}
