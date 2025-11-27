class ApiPath {
  //auth
  static const String authRegister = 'auth/register';
  static const String authLogin = 'auth/login';
  static const String authRefresh = 'auth/refresh-token';
  static const String authRequestOtp = 'auth/request-otp';
  static const String authVerifyOtp = 'auth/verify-otp';
  static const String changePass = 'auth/change-password';

  static const String categoryList = 'category/list';
  static const String searchPost = 'post/search-post';
  static const String postDetail = 'post/detail/';
  static const String postUpdate = 'post/update';
  static const String postCreate = 'post/create';
  static const String postUpdateStatus = 'post/update-status';
  static const String postUpdateExtension = 'post/update-extension-post'; // gia hanj tin dang

  //user
  static const String getProfile = 'user/profile';
  static const String createWallet = 'user/create-pin-wallet';
  static const String updatePinWallet = 'user/update-pin-wallet';
  static const String updateAvatar = 'user/upload-avatar';
  static const String updateProfile = 'user/update-user';

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
  static const String reviewListByUser = 'review/list-by-tab';

  //violation: nội dung vi phạm
  static const String getViolationList = 'violation/get-all';

  //report
  static const String createReport = 'report/create';

  //payment
  static const String payment = 'payment/create-payment';
  static const String paymentPurchase = 'payment/create-payment-package'; //user mua gói
  static const String userPayment = 'payment/get-payments-by-userId'; // user đang sở hữu gói

  //package
  static const String getPackages = 'payment-package';
}
