import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/auction/category/domain/models/auction_category_model.dart';
import 'package:sixvalley_vendor_app/features/auction/category/domain/services/auction_category_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class AuctionCategoryController with ChangeNotifier {
  final AuctionCategoryServiceInterface auctionCategoryServiceInterface;
  AuctionCategoryController({required this.auctionCategoryServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<AuctionCategoryModel>? _categoryList;
  List<AuctionCategoryModel>? get categoryList => _categoryList;

  Future<void> getCategoryList({int limit = 200, int offset = 1, bool reload = false, bool isUpdate = true}) async {
    if (!reload && _categoryList != null && _categoryList!.isNotEmpty) {
      return;
    }

    _isLoading = true;
    if (isUpdate) {
      notifyListeners();
    }

    final ApiResponse apiResponse = await auctionCategoryServiceInterface.getCategoryList(limit: limit, offset: offset);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _categoryList = AuctionCategoryListModel.fromJson(apiResponse.response!.data).categories;
    } else {
      _categoryList = [];
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }
}
