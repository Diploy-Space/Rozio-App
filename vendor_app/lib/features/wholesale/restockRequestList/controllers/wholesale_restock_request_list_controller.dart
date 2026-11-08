import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/domain/models/wholesale_restock_brand_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/domain/models/wholesale_restock_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/domain/services/wholesale_restock_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class WholesaleRestockRequestListController with ChangeNotifier {
  final WholesaleRestockServiceInterface wholesaleRestockServiceInterface;
  WholesaleRestockRequestListController({required this.wholesaleRestockServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  String? _searchText;
  String? get searchText => _searchText;

  WholesaleRestockProductListModel? restockProductModel;

  List<WholesaleRestockBrand>? brands;

  int _categoryIndex = 0;
  int get categoryIndex => _categoryIndex;

  int? _categoryId;
  int? get categoryId => _categoryId;

  String? _startDate;
  String? get startDate => _startDate;

  String? _endDate;
  String? get endDate => _endDate;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  List<TextEditingController> variationQuantityController = [];
  List<FocusNode> variationQuantityFocusnode = [];

  final TextEditingController _totalQuantityController = TextEditingController(text: '1');
  TextEditingController get totalQuantityController => _totalQuantityController;

  List<int> _selectedBrandIds = [];
  List<int> get selectedBrandIds => _selectedBrandIds;

  Future<void> getRestockBrandList() async {
    brands = [];
    _isLoading = true;
    ApiResponse apiResponse = await wholesaleRestockServiceInterface.getRestockBrandList();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      brands = WholesaleRestockBrandListModel.fromJson(apiResponse.response?.data).brands;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteRestockListItem(int id, int index) async {
    _isLoading = true;
    ApiResponse apiResponse = await wholesaleRestockServiceInterface.deleteRestockItem(id);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if (restockProductModel?.data != null && index < restockProductModel!.data!.length) {
        restockProductModel!.data!.removeAt(index);
        restockProductModel!.totalSize = (restockProductModel!.totalSize ?? 1) - 1;
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getRestockProductList(int offset) async {
    if (offset == 1) {
      restockProductModel = null;
      _isLoading = true;
    } else {
      if (_isLoadingMore) {
        return;
      }
      _isLoadingMore = true;
    }
    notifyListeners();

    List<int> selectedBrandIdsList = [];
    for (WholesaleRestockBrand brand in brands ?? []) {
      if (brand.checked ?? false) {
        selectedBrandIdsList.add(brand.id!);
      }
    }

    ApiResponse apiResponse = await wholesaleRestockServiceInterface.getRestockProductList(
      offset: offset,
      categoryId: _categoryId,
      search: _searchText,
      brandIds: selectedBrandIdsList,
      startDate: _startDate,
      endDate: _endDate,
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      WholesaleRestockProductListModel result = WholesaleRestockProductListModel.fromJson(apiResponse.response!.data);
      if (offset == 1) {
        restockProductModel = result;
      } else {
        restockProductModel!.data!.addAll(result.data ?? []);
        restockProductModel!.offset = result.offset ?? offset;
        restockProductModel!.totalSize = result.totalSize;
        restockProductModel!.lastPage = result.lastPage;
      }
    } else {
      if (offset == 1) {
        restockProductModel = WholesaleRestockProductListModel(data: [], totalSize: 0, limit: 10, offset: 1);
      }
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  void emptyReStockData() {
    restockProductModel = null;
    notifyListeners();
  }

  void setIndex(int index, int? id, {bool notify = true}) {
    _categoryIndex = index;
    _categoryId = id;
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> selectDate(BuildContext context, String startDate, String endDate) async {
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
  }

  void setSearching(bool value, {bool isUpdate = true}) {
    _isSearching = value;
    if (!value) {
      _searchText = null;
    }
    if (isUpdate) {
      notifyListeners();
    }
  }

  void setSearchText(String? value) {
    _searchText = value;
  }

  void checkedToggleBrand(int index) {
    brands![index].checked = !(brands![index].checked ?? false);

    if (brands![index].checked ?? false) {
      if (!_selectedBrandIds.contains(index)) {
        _selectedBrandIds.add(index);
      }
    } else {
      _selectedBrandIds.remove(index);
    }
    notifyListeners();
  }

  Future<void> resetChecked() async {
    _startDate = null;
    _endDate = null;

    brands = brands?.map((brand) {
      brand.checked = false;
      return brand;
    }).toList();
    _selectedBrandIds = [];

    await getRestockProductList(1);
    notifyListeners();
  }

  void initVariationController(List<WholesaleRestockVariation> variations) {
    variationQuantityController = [];
    variationQuantityFocusnode = [];
    for (WholesaleRestockVariation v in variations) {
      variationQuantityController.add(TextEditingController(text: v.qty.toString()));
      variationQuantityFocusnode.add(FocusNode());
    }
    calculateVariationQuantity();
  }

  Future<void> updateRestockProductQuantity(BuildContext context, WholesaleRestockRequestData? restockRequest, int currentStock, List<WholesaleRestockVariation> variations) async {
    if (restockRequest?.id == null) {
      return;
    }

    List<WholesaleRestockVariation> updatedVariations = [];
    for (int i = 0; i < variations.length; i++) {
      updatedVariations.add(WholesaleRestockVariation(
        type: variations[i].type,
        sku: variations[i].sku,
        price: variations[i].price,
        qty: int.tryParse(variationQuantityController[i].text) ?? 0,
      ));
    }

    final requestedStock = requestedVariationStock(restockRequest!, updatedVariations, currentStock);

    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await wholesaleRestockServiceInterface.updateRestockProductQuantity(
      restockRequest.id!,
      currentStock: currentStock,
      variation: updatedVariations,
      variationType: requestedStock.type,
      variationQty: requestedStock.qty,
    );
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      Navigator.pop(Get.context!);
      showCustomSnackBarWidget(getTranslated('quantity_updated_successfully', Get.context!), Get.context!, isError: false);
      await getRestockProductList(1);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  static ({String type, int qty}) requestedVariationStock(WholesaleRestockRequestData restockRequest, List<WholesaleRestockVariation> variations, int currentStock) {
    final List<String> requestedKeys = [
      if (restockRequest.variant != null && restockRequest.variant!.isNotEmpty) restockRequest.variant!,
      ...?restockRequest.variantKeys,
    ];
    final int requestedIndex = variations.indexWhere((variation) => requestedKeys.contains(variation.type));

    if (requestedIndex < 0) {
      return (type: restockRequest.variant ?? '', qty: currentStock);
    }
    return (type: variations[requestedIndex].type ?? '', qty: variations[requestedIndex].qty ?? 0);
  }

  void calculateVariationQuantity() {
    int variationTotalQuantity = 0;
    if (variationQuantityController.isNotEmpty) {
      for (int i = 0; i < variationQuantityController.length; i++) {
        variationTotalQuantity = variationTotalQuantity + (int.tryParse(variationQuantityController[i].text) ?? 0);
      }
    }
    _totalQuantityController.text = variationTotalQuantity.toString();
    notifyListeners();
  }

  void setCurrentStock(String stock) {
    _totalQuantityController.text = stock;
  }
}
