import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_product_detail_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/domain/models/wholesale_limited_stock_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/domain/services/wholesale_limited_stock_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class WholesaleLimitedStockController with ChangeNotifier {
  final WholesaleLimitedStockServiceInterface wholesaleLimitedStockServiceInterface;
  WholesaleLimitedStockController({required this.wholesaleLimitedStockServiceInterface});

  List<WholesaleLimitedStockProductModel>? _productList;
  List<WholesaleLimitedStockProductModel>? get productList => _productList;

  int? _totalSize;
  int? get totalSize => _totalSize;

  int? _offset;
  int? get offset => _offset;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  int? _stockLoadingProductId;
  bool isStockLoading(int? productId) => productId != null && _stockLoadingProductId == productId;

  Future<void> getStockOutProductList({int offset = 1, bool reload = false, bool isUpdate = true}) async {
    if (reload) {
      _productList = null;
      if (isUpdate) {
        notifyListeners();
      }
    }

    final ApiResponse apiResponse = await wholesaleLimitedStockServiceInterface.getStockOutProductList(offset: offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final ApiListEnvelope envelope = ApiListEnvelope.fromJson(apiResponse.response!.data);
      final List<WholesaleLimitedStockProductModel> products = envelope.data
          ?.whereType<Map>().map((product) => WholesaleLimitedStockProductModel.fromJson(Map<String, dynamic>.from(product))).toList() ?? [];

      if (offset == 1 || _productList == null) {
        _productList = products;
      } else {
        _productList!.addAll(products);
      }
      _totalSize = envelope.totalSize;
      _offset = envelope.offset ?? offset;
    } else {
      _productList ??= [];
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<WholesaleLimitedStockProductModel?> getProductStock(WholesaleLimitedStockProductModel product) async {
    if (product.id == null || _stockLoadingProductId != null) return null;
    _stockLoadingProductId = product.id;
    notifyListeners();

    WholesaleLimitedStockProductModel? productWithStock;
    final ApiResponse apiResponse = await wholesaleLimitedStockServiceInterface.getProductStock(product.id!);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic data = apiResponse.response!.data;
      final dynamic details = data is Map && data['data'] is Map ? data['data'] : data;
      if (details is Map) {
        productWithStock = product.withStock(WholesaleProductDetailModel.fromJson(Map<String, dynamic>.from(details)));
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _stockLoadingProductId = null;
    notifyListeners();
    return productWithStock;
  }

  List<TextEditingController> variationQuantityController = [];
  List<FocusNode> variationQuantityFocusNode = [];
  final TextEditingController totalQuantityController = TextEditingController(text: '0');

  void initVariationControllers(WholesaleLimitedStockProductModel product) {
    for (final controller in variationQuantityController) {
      controller.dispose();
    }
    for (final node in variationQuantityFocusNode) {
      node.dispose();
    }

    variationQuantityController = [];
    variationQuantityFocusNode = [];
    for (final variation in product.variation) {
      variationQuantityController.add(TextEditingController(text: variation.qty.toString()));
      variationQuantityFocusNode.add(FocusNode());
    }
    calculateVariationQuantity(isUpdate: false);
  }

  void calculateVariationQuantity({bool isUpdate = true}) {
    int total = 0;
    for (final controller in variationQuantityController) {
      total += int.tryParse(controller.text) ?? 0;
    }
    totalQuantityController.text = total.toString();
    if (isUpdate) {
      notifyListeners();
    }
  }

  List<WholesaleLimitedStockVariation> editedVariations(WholesaleLimitedStockProductModel product) {
    return [
      for (int i = 0; i < product.variation.length; i++)
        WholesaleLimitedStockVariation(
          type: product.variation[i].type,
          sku: product.variation[i].sku,
          price: product.variation[i].price,
          qty: int.tryParse(variationQuantityController[i].text.trim()) ?? 0,
        ),
    ];
  }

  Future<bool> updateProductQuantity(int productId, int currentStock, List<WholesaleLimitedStockVariation> variations) async {
    if (_isUpdating) return false;
    _isUpdating = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleLimitedStockServiceInterface.updateProductQuantity(productId, currentStock, variations);
    final bool isSuccess = apiResponse.response != null && apiResponse.response!.statusCode == 200;
    if (isSuccess) {
      showCustomSnackBarWidget(getTranslated('quantity_updated_successfully', Get.context!), Get.context!, isError: false);
      getStockOutProductList();
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isUpdating = false;
    notifyListeners();
    return isSuccess;
  }
}
