import 'dart:io';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';
import 'package:sixvalley_vendor_app/features/profile/domain/models/profile_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/profile/domain/models/profile_info.dart';
import 'package:sixvalley_vendor_app/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/profile/domain/services/profice_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/main.dart';

class ProfileService implements ProfileServiceInterface{
  final ProfileRepositoryInterface profileRepoInterface;
  ProfileService({required this.profileRepoInterface});

  @override
  Future deleteUserAccount() async{
    ApiResponse apiResponse = await profileRepoInterface.deleteUserAccount();
    if (apiResponse.response?.statusCode == 200) {
      showCustomSnackBarWidget(ApiEnvelope.message(apiResponse.response!.data), Get.context!, isToaster: true, isError: false);
    } else if (apiResponse.response == null) {
      ApiChecker.checkApi(apiResponse);
    }
    return apiResponse;
  }



  @override
  Future getSellerInfo() {
    return profileRepoInterface.getSellerInfo();
  }


  @override
  Future getVerificationCriteria() {
    return profileRepoInterface.getVerificationCriteria();
  }

  @override
  Future updateProfile(ProfileInfoModel userInfoModel, ProfileBody seller, File? file, String token, String password) {
    return profileRepoInterface.updateProfile(userInfoModel, seller, file, token, password);
  }

}