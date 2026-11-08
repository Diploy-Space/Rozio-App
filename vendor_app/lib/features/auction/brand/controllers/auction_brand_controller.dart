import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/auction/brand/domain/models/auction_brand_model.dart';
import 'package:sixvalley_vendor_app/features/auction/brand/domain/services/auction_brand_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class AuctionBrandController with ChangeNotifier {
  final AuctionBrandServiceInterface auctionBrandServiceInterface;
  AuctionBrandController({required this.auctionBrandServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<AuctionBrandModel>? _brandList;
  List<AuctionBrandModel>? get brandList => _brandList;

  Future<void> getBrandList({int limit = 200, int offset = 1, bool reload = false, bool isUpdate = true}) async {
    if (!reload && _brandList != null && _brandList!.isNotEmpty) {
      return;
    }

    _isLoading = true;
    if (isUpdate) {
      notifyListeners();
    }

    final ApiResponse apiResponse = await auctionBrandServiceInterface.getBrandList(limit: limit, offset: offset);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _brandList = AuctionBrandListModel.fromJson(apiResponse.response!.data).brands;
    } else {
      _brandList = [];
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }
}
