

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/shop_model.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/vacation_model.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/withdrawal_method_model.dart';

abstract class ShopServiceInterface{
  Future<dynamic> getShop();
  Future<dynamic> updateShop(ShopModel userInfoModel,  File? file, XFile? shopBanner, XFile? secondaryBanner, XFile? offerBanner,
      {String? minimumOrderAmount, String? freeDeliveryStatus, String? freeDeliveryOverAmount, String? wholesaleFreeDeliveryStatus, String? wholesaleFreeDeliveryOverAmount, String? taxIdentificationNumber, String? tinExpireDate, String? stockLimit, XFile? tinCertificate,
      String? wholesaleTaxIdentificationNumber, String? wholesaleTinExpireDate, XFile? wholesaleTinCertificate,
      String? auctionTaxIdentificationNumber, String? auctionTinExpireDate, XFile? auctionTinCertificate});
  Future<dynamic> vacation(VacationModel vacationModel);
  Future<dynamic> temporaryClose(List<String> status);
  Future<dynamic> getPaymentWithdrawalMethodList();
  Future<dynamic> addPaymentInfo(WithdrawAddModel withdrawAddModel,bool isUpdate);
  Future<dynamic> getPaymentInfoList(int? offset);
  Future<dynamic> updateConfigStatus(bool status, int id);
  Future<dynamic> deletePaymentMethod(int id);
  Future<dynamic> setDefaultPaymentMethod(int id);
  Future<dynamic> updateSetupGuideApp(String key, int value);
  Future<dynamic> downloadTinCertificate(String url);
}