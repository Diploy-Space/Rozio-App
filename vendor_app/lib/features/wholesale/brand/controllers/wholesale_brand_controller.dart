import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/brand/domain/models/wholesale_brand_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/brand/domain/services/wholesale_brand_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class WholesaleBrandController with ChangeNotifier {
  final WholesaleBrandServiceInterface wholesaleBrandServiceInterface;
  WholesaleBrandController({required this.wholesaleBrandServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<WholesaleBrandModel>? _brandList;
  List<WholesaleBrandModel>? get brandList => _brandList;

  int? _selectedBrandId;
  int? get selectedBrandId => _selectedBrandId;

  void setSelectedBrandId(int? brandId, {bool notify = true}) {
    _selectedBrandId = brandId;
    if (notify) notifyListeners();
  }

  Future<void> getBrandList({int limit = 200, int offset = 1, bool reload = false, bool isUpdate = true}) async {
    if (!reload && _brandList != null && _brandList!.isNotEmpty) {
      return;
    }

    _isLoading = true;
    if (isUpdate) {
      notifyListeners();
    }

    final ApiResponse apiResponse = await wholesaleBrandServiceInterface.getBrandList(limit: limit, offset: offset);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _brandList = WholesaleBrandListModel.fromJson(apiResponse.response!.data).brands;
    } else {
      _brandList = [];
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  String? brandNameOf(int? brandId) {
    if (brandId == null || _brandList == null) {
      return null;
    }
    for (final WholesaleBrandModel brand in _brandList!) {
      if (brand.id == brandId) {
        return brand.name;
      }
    }
    return null;
  }

  void reset({bool notify = true}) {
    _selectedBrandId = null;
    if (notify) notifyListeners();
  }
}
