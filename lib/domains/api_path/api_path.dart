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
  static const String searchFavorite = 'favorite/search';

  //history
  static const String searchHistory = 'history/search';

  //reviews
  static const String reviewList = 'review/list';
  static const String createReview = 'review/create';
  static const String deleteReview = 'review/delete';
  static const String updateReview = 'review/update';

  //violation: nội dung vi phạm
  static const String getViolationList = 'violation/get-all';

  //report
  static const String createReport = 'report/create';
}
