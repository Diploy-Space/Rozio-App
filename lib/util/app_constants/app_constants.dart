class AppConstants {
  static const String appName = 'Merigo';
  static const double appVersion = 1.0;
  // static const AppMode appMode = AppMode.release;
  static const String fontFamily = 'Exo';
  static const String baseUrl = 'http://jacob-merigo.thesyndicates.team/api';

  //Authentication
  static const String signIn = '/auth/login';
  static const String signUp = '/auth/register';

  // chore board

  static String verifyOtp() => "/auth/verify-email";
  static String forgotPassword() => "/auth/forgot-password";
  static String authResendOtp() => "/auth/resend-otp";
  static String authResetPassword() => "/auth/reset-password";
  static String authVerifyPasswordResetOtp() =>
      "/auth/verify-password-reset-otp";
  static String logout() => "/auth/logout";

  // Shared Key
  static const String token = 'token';
  static const String userId = 'userId';
  static const String onBoardingSkip = 'on_boarding_skip';
  static const String langSkip = 'lang_skip';
  static const String guestId = 'guest_id';
  static const String fcmToken = 'fcmToken';
  static const String deviceId = 'deviceId';

  //my bar list

  static String myBarList() => "/bars/my-bar";
  static String singleBar({required int id}) => "/bars/single-bar/$id/show";
  static String myDeals() => "/deals/admin/my-deals";
  static String profileGet() => "/profile/user/who-i-am";
  static String profileUpdate() => "/profile/update";
  static String createDeal() => "/deals/store";
  static String transactions() => "/wallets/transactions/index";

  //------------event------------

  static String myEvents() => "/events/admin/my-evens";
  static String singleEvent({required String id}) => "/events/$id/show";
  static String allEvents() => "/events/index";
  static String createEvent() => "/events/store";
  static String deleteEvent({required String id}) => "/events/$id/delete";
  static String eventIndex() => "/events/index";
  static String indexBarDeals() => "/deals/bars/index";

  static String updateEvent() => "/events/store";
  static String barTransaction() => "/wallets/bar/index";
  static String merigoWallet() => "/wallets/merigo/my-wallet";
  static String dealPurchase() => "/wallets/transactions/deal";
  static String transactionsList() => "/wallets/transactions/index";
  static String allMerchandise() => "/merchandise/all-goods/index";
  static String merchandiseRequest({required int id}) =>
      "/merchandise/$id/request";

  //------------ads/banner----------
  static String adsShow() => "/ads/show";

  //--------------check in---------------
  static String checkinBarList = "/bars/index";
  static String checkInBar = "/wallets/transactions/check-in";
}
