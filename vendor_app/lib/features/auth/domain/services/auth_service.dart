import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/error_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/features/auth/domain/models/register_model.dart';
import 'package:sixvalley_vendor_app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/auth/domain/services/auth_service_interface.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class AuthService implements AuthServiceInterface{
  final AuthRepositoryInterface authRepoInterface;
  AuthService({required this.authRepoInterface});

  @override
  Future clearSharedData() {
   return authRepoInterface.clearSharedData();
  }

  @override
  Future clearUserNumberAndPassword(){
    return authRepoInterface.clearUserNumberAndPassword();
  }

  @override
  Future forgotPassword(String identity) async{
    ApiResponse apiResponse = await authRepoInterface.forgotPassword(identity);
    return _toResponseModel(apiResponse);
  }

  ResponseModel _toResponseModel(ApiResponse apiResponse) {
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      return ResponseModel(true, ApiEnvelope.message(apiResponse.response!.data));
    }
    String? errorMessage;
    if (apiResponse.error is ErrorResponse) {
      errorMessage = (apiResponse.error as ErrorResponse).errors?.firstOrNull?.message;
    } else if (apiResponse.error != null) {
      errorMessage = apiResponse.error.toString();
    }
    if (kDebugMode) {
      print(errorMessage);
    }
    return ResponseModel(false, errorMessage);
  }

  @override
  String getUserEmail() {
    return authRepoInterface.getUserEmail();

  }

  @override
  String getUserPassword() {
    return authRepoInterface.getUserPassword();
  }

  @override
  String getUserToken() {
    return authRepoInterface.getUserToken();

  }

  @override
  bool isLoggedIn() {
    return authRepoInterface.isLoggedIn();
  }

  @override
  Future login({String? emailAddress, String? password}) async{
    ApiResponse apiResponse = await authRepoInterface.login(emailAddress: emailAddress, password: password);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map? content = apiResponse.response!.data['content'];
      String token = content?['token'] ?? '';
      saveUserToken(token);
    } else if (apiResponse.error == 'pending'){
      showCustomSnackBarWidget(getTranslated('your_account_is_in_review_process', Get.context!), Get.context!, sanckBarType: SnackBarType.error);
    } else if(apiResponse.error == 'unauthorized'){
      showCustomSnackBarWidget(getTranslated('invalid_credential', Get.context!), Get.context!, sanckBarType: SnackBarType.error);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error;
      } else if (apiResponse.error is ErrorResponse) {
        errorMessage = (apiResponse.error as ErrorResponse).errors?.first.message;
      }
      showCustomSnackBarWidget((errorMessage?.isNotEmpty ?? false) ? errorMessage : getTranslated('account_not_verified_yet', Get.context!), Get.context!, sanckBarType: SnackBarType.error);
    }
    return apiResponse;
  }

  @override
  Future registration(XFile? profileImage, XFile? shopLogo, XFile? shopBanner, XFile? secondaryBanner, RegisterModel registerModel, XFile? tinCertificate) async{
    return authRepoInterface.registration(profileImage, shopLogo, shopBanner, secondaryBanner, registerModel, tinCertificate);
  }

  @override
  Future resetPassword(String identity, String otp, String password, String confirmPassword) async{
    ApiResponse apiResponse = await authRepoInterface.resetPassword(identity, otp, password, confirmPassword);
    return _toResponseModel(apiResponse);
  }

  @override
  Future<void> saveUserNumberAndPassword(String number, String password) {
    return authRepoInterface.saveUserCredentials(number, password);
  }

  @override
  Future<void> saveUserToken(String token) {
    return authRepoInterface.saveUserToken(token);
  }

  @override
  Future setLanguageCode(String languageCode) {
    return authRepoInterface.setLanguageCode(languageCode);
  }

  @override
  Future updateToken() async{
      ApiResponse apiResponse = await authRepoInterface.updateToken();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      return apiResponse;
    } else {
      // ApiChecker.checkApi(apiResponse);
    }
  }

  @override
  Future verifyOtp(String identity, String otp) async{
   ApiResponse apiResponse = await authRepoInterface.verifyOtp(identity, otp);
   return _toResponseModel(apiResponse);
  }


  @override
  Future firebaseAuthTokenStore({required String userInput, required String token}) {
    return authRepoInterface.firebaseAuthTokenStore(userInput, token);
  }

  @override
  Future firebaseAuthVerify({required String phoneNumber, required String session, required String otp, required bool isForgetPassword}) {
    return authRepoInterface.firebaseAuthVerify(phoneNumber: phoneNumber, session: session, otp: otp, isForgetPassword: isForgetPassword);
  }

  @override
  Future checkVendorExistPhone({required String phoneNumber}) {
    return authRepoInterface.checkVendorExistPhone(phoneNumber: phoneNumber);
  }

}