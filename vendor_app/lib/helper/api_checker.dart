import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/auth/screens/auth_screen.dart';

class ApiChecker {
  static bool _isLoggingOut = false;

  static Future<void> _logoutOnUnauthorized() async {
    final AuthController authController = Provider.of<AuthController>(Get.context!, listen: false);
    if (_isLoggingOut || !authController.isLoggedIn()) {
      return;
    }

    _isLoggingOut = true;
    try {
      authController.setUnAuthorize(true, update: true);
      await authController.clearSharedData(fromUnAuthorizationError: true);

      Navigator.of(Get.context!).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthScreen()), (route) => false);
      showCustomSnackBarWidget(getTranslated('session_expired_please_login_again', Get.context!), Get.context!, sanckBarType: SnackBarType.error);
    } catch (ex) {
      debugPrint("===RouteException==>>$ex");
    } finally {
      _isLoggingOut = false;
    }
  }

  static void checkApi(ApiResponse apiResponse,  {bool firebaseResponse = false}) {
    if(apiResponse.error.toString() == 'unauthorized') {
      _logoutOnUnauthorized();
    }else {
      String? errorMessage;
      if (apiResponse.error == null) {
        errorMessage = ApiEnvelope.errorMessage(apiResponse.response?.data);
      } else if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        final dynamic errors = apiResponse.error.errors;
        errorMessage = (errors is List && errors.isNotEmpty) ? errors[0].message : ApiEnvelope.errorMessage(apiResponse.response?.data);
      }
      if (kDebugMode) {
        print(errorMessage);
      }
      if(errorMessage != ''){
        showCustomSnackBarWidget(firebaseResponse ? errorMessage?.replaceAll('_', ' ') : errorMessage, Get.context!, sanckBarType: SnackBarType.error);
      }
    }
  }
}