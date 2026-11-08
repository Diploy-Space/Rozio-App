import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/shipping/domain/models/category_wise_shipping_model.dart';
import 'package:sixvalley_vendor_app/features/shipping/domain/models/shipping_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/shipping/domain/services/wholesale_shipping_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/interface/shipping_type_host.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class WholesaleShippingController extends ChangeNotifier implements ShippingTypeHost {
  final WholesaleShippingServiceInterface wholesaleShippingServiceInterface;
  WholesaleShippingController({required this.wholesaleShippingServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ShippingModel>? _shippingList;
  List<ShippingModel>? get shippingList => _shippingList;

  final Set<int> _statusUpdatingIds = {};
  bool isStatusUpdating(int? id) => id != null && _statusUpdatingIds.contains(id);

  Future<void> getShippingList() async {
    final List<ShippingModel> shippingList = [];
    int offset = 1;
    int lastPage = 1;
    do {
      final ApiResponse apiResponse = await wholesaleShippingServiceInterface.getShippingMethod(offset: offset);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        final ApiListEnvelope envelope = ApiListEnvelope.fromJson(apiResponse.response!.data);
        envelope.data?.whereType<Map>().forEach((shipping) => shippingList.add(ShippingModel.fromJson(Map<String, dynamic>.from(shipping))));
        lastPage = envelope.lastPage ?? offset;
      } else {
        _shippingList ??= [];
        ApiChecker.checkApi(apiResponse);
        notifyListeners();
        return;
      }
      offset++;
    } while (offset <= lastPage);

    _shippingList = shippingList;
    notifyListeners();
  }

  Future<bool> addShippingMethod(ShippingModel shipping) async {
    _isLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleShippingServiceInterface.addShipping(shipping);
    final int? statusCode = apiResponse.response?.statusCode;
    final bool isSuccess = statusCode == 200 || statusCode == 201;
    if (isSuccess) {
      getShippingList();
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> updateShippingMethod(String? title, String? duration, double? cost, int? id) async {
    _isLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleShippingServiceInterface.updateShipping(title, duration, cost, id);
    final bool isSuccess = apiResponse.response != null && apiResponse.response!.statusCode == 200;
    if (isSuccess) {
      getShippingList();
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<void> deleteShipping(int? id) async {
    if (id == null || _isLoading) return;
    _isLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleShippingServiceInterface.deleteShipping(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Navigator.pop(Get.context!);
      showCustomSnackBarWidget(getTranslated('shipping_method_deleted_successfully', Get.context!), Get.context!, isError: false);
      getShippingList();
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> shippingOnOff(ShippingModel shipping, int status) async {
    if (shipping.id == null || _statusUpdatingIds.contains(shipping.id)) return;
    _statusUpdatingIds.add(shipping.id!);
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleShippingServiceInterface.shippingOnOff(shipping.id, status);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      shipping.status = status;
      showCustomSnackBarWidget(getTranslated('status_updated_successfully', Get.context!), Get.context!, isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _statusUpdatingIds.remove(shipping.id);
    notifyListeners();
  }

  List<AllCategoryShippingCost>? _categoryWiseShipping;
  List<AllCategoryShippingCost>? get categoryWiseShipping => _categoryWiseShipping;

  List<int?> _ids = [];
  List<int?> get ids => _ids;

  List<bool> _isMultiply = [];
  List<int> _isMultiplyInt = [];
  List<bool> get isMultiply => _isMultiply;
  List<int> get isMultiplyInt => _isMultiplyInt;

  List<TextEditingController> _shippingCostController = [];
  List<FocusNode> _shippingCostNode = [];
  List<TextEditingController> get shippingCostController => _shippingCostController;
  List<FocusNode> get shippingCostNode => _shippingCostNode;

  void toggleMultiply(BuildContext context, bool isOk, int index) {
    _isMultiply[index] = isOk;
    _isMultiplyInt[index] = isOk ? 1 : 0;
    notifyListeners();
  }

  Future<void> getCategoryWiseShippingMethod() async {
    final ApiResponse apiResponse = await wholesaleShippingServiceInterface.getCategoryWiseShippingMethod();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final ApiListEnvelope envelope = ApiListEnvelope.fromJson(apiResponse.response!.data, legacyKeys: ['all_category_shipping_cost']);
      final List<AllCategoryShippingCost> categoryWiseShipping = envelope.data?.whereType<Map>()
          .map((cost) => AllCategoryShippingCost.fromJson(Map<String, dynamic>.from(cost))).toList() ?? [];

      _categoryWiseShipping = categoryWiseShipping;
      _ids = categoryWiseShipping.map((cost) => cost.categoryId).toList();
      _isMultiply = categoryWiseShipping.map((cost) => cost.multiplyQty ?? false).toList();
      _isMultiplyInt = _isMultiply.map((isMultiply) => isMultiply ? 1 : 0).toList();
      _shippingCostController = categoryWiseShipping
          .map((cost) => TextEditingController(text: PriceConverter.convertPriceWithoutSymbol(Get.context!, cost.cost)))
          .toList();
      _shippingCostNode = List.generate(categoryWiseShipping.length, (_) => FocusNode());
    } else {
      _categoryWiseShipping ??= [];
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<bool> setCategoryWiseShippingCost(List<int?> ids, List<double> cost, List<int> multiPly) async {
    _isLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleShippingServiceInterface.setCategoryWiseShippingCost(ids, cost, multiPly);
    final bool isSuccess = apiResponse.response != null && apiResponse.response!.statusCode == 200;
    if (isSuccess) {
      showCustomSnackBarWidget(getTranslated('category_cost_updated_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
      getCategoryWiseShippingMethod();
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  int _shippingIndex = 0;
  @override
  int get shippingIndex => _shippingIndex;

  @override
  void setShippingType(int index) {
    _shippingIndex = index;
    notifyListeners();
  }

  @override
  Future<void> getSelectedShippingMethodType(BuildContext context) async {
    final ApiResponse apiResponse = await wholesaleShippingServiceInterface.getSelectedShippingMethodType();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic type = ApiEnvelope.content(apiResponse.response!.data)['type'];
      setShippingType(type == 'order_wise' ? 0 : type == 'product_wise' ? 1 : 2);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  @override
  Future<ApiResponse> setShippingMethodType(BuildContext context, String? type) async {
    final ApiResponse apiResponse = await wholesaleShippingServiceInterface.setShippingMethodType(type);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBarWidget(getTranslated('shipping_method_updated_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    return apiResponse;
  }
}
