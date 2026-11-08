import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/domain/models/wholesale_coupon_customer_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/domain/models/wholesale_coupon_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/domain/models/wholesale_coupon_setup_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/domain/services/wholesale_coupon_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class WholesaleCouponController with ChangeNotifier {
  final WholesaleCouponServiceInterface wholesaleCouponServiceInterface;
  WholesaleCouponController({required this.wholesaleCouponServiceInterface});

  WholesaleCouponModel? _couponModel;
  WholesaleCouponModel? get couponModel => _couponModel;

  WholesaleCouponSetupModel _setupModel = WholesaleCouponSetupModel.fallback();
  WholesaleCouponSetupModel get setupModel => _setupModel;

  List<WholesaleCouponCustomer>? _couponCustomerList;
  List<WholesaleCouponCustomer>? get couponCustomerList => _couponCustomerList;

  int? _selectedCustomerId;
  int? get selectedCustomerId => _selectedCustomerId;
  String _selectedCustomerName = '';
  String get selectedCustomerName => _selectedCustomerName;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isCustomerLoading = false;
  bool get isCustomerLoading => _isCustomerLoading;
  bool _isAdd = false;
  bool get isAdd => _isAdd;

  String? _selectedCouponType;
  String? get selectedCouponType => _selectedCouponType;
  String? _discountTypeName = 'amount';
  String? get discountTypeName => _discountTypeName;

  List<String> get couponTypeList => _setupModel.couponTypes.keys.toList();
  List<String> get discountTypeList => _setupModel.discountTypes.keys.toList();
  WholesaleCouponFieldVisibility get fieldVisibility => _setupModel.visibilityOf(_selectedCouponType);

  DateTime? startDate;
  DateTime? endDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  DateFormat get dateFormat => _dateFormat;

  int _requestedCustomerSearch = 0;

  void setSelectedCouponType(String? type) {
    _selectedCouponType = type;
    notifyListeners();
  }

  void setSelectedDiscountNameType(String? type) {
    _discountTypeName = type;
    notifyListeners();
  }

  void initCouponForm(WholesaleCoupon? coupon) {
    _isAdd = false;
    if (coupon != null) {
      _selectedCouponType = coupon.couponType ?? 'discount_on_purchase';
      _discountTypeName = coupon.discountType ?? 'amount';
      _selectedCustomerId = coupon.customerId ?? 0;
      _selectedCustomerName = _selectedCustomerId == 0 ? (getTranslated('all_customer', Get.context!) ?? '') : '';
      startDate = DateTime.tryParse(coupon.startDate ?? '');
      endDate = DateTime.tryParse(coupon.expireDate ?? '');
    } else {
      _selectedCouponType = null;
      _discountTypeName = 'amount';
      _selectedCustomerId = null;
      _selectedCustomerName = '';
      startDate = null;
      endDate = null;
    }
  }

  Future<void> getCouponSetup() async {
    final ApiResponse apiResponse = await wholesaleCouponServiceInterface.getCouponSetup();
    if (apiResponse.response?.statusCode == 200) {
      final WholesaleCouponSetupModel setup = WholesaleCouponSetupModel.fromJson(apiResponse.response!.data);
      if (setup.couponTypes.isNotEmpty && setup.discountTypes.isNotEmpty) {
        _setupModel = setup;
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    if (_selectedCouponType != null && !couponTypeList.contains(_selectedCouponType) && couponTypeList.isNotEmpty) {
      _selectedCouponType = couponTypeList.first;
    }
    if (!discountTypeList.contains(_discountTypeName) && discountTypeList.isNotEmpty) {
      _discountTypeName = discountTypeList.first;
    }
    notifyListeners();
  }

  Future<void> getCouponList(int offset) async {
    if (offset == 1) {
      _isLoading = true;
    }
    final ApiResponse apiResponse = await wholesaleCouponServiceInterface.getCouponList(offset);
    if (apiResponse.response?.statusCode == 200) {
      final WholesaleCouponModel couponModel = WholesaleCouponModel.fromJson(apiResponse.response!.data);
      if (offset == 1 || _couponModel == null) {
        _couponModel = couponModel;
      } else {
        _couponModel!.totalSize = couponModel.totalSize;
        _couponModel!.offset = couponModel.offset;
        _couponModel!.coupons!.addAll(couponModel.coupons ?? []);
      }
    } else {
      _couponModel ??= WholesaleCouponModel(coupons: []);
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveCoupon(WholesaleCoupon coupon, bool update) async {
    _isAdd = true;
    notifyListeners();

    final WholesaleCouponFieldVisibility visibility = _setupModel.visibilityOf(coupon.couponType);
    final Map<String, dynamic> body = coupon.toPayload(targeting: visibility.targeting, discountEnabled: visibility.discount);
    final ApiResponse apiResponse = update
        ? await wholesaleCouponServiceInterface.updateCoupon(body, coupon.id!)
        : await wholesaleCouponServiceInterface.addCoupon(body);

    final int? statusCode = apiResponse.response?.statusCode;
    _isAdd = false;
    if (statusCode == 200 || statusCode == 201) {
      getCouponList(1);
      startDate = null;
      endDate = null;
      Navigator.pop(Get.context!);
      showCustomSnackBarWidget(getTranslated(update ? 'coupon_updated_successfully' : 'coupon_added_successfully', Get.context!), Get.context!, isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> updateCouponStatus(int? id, bool status, int? index) async {
    final ApiResponse apiResponse = await wholesaleCouponServiceInterface.updateCouponStatus(id, status);
    if (apiResponse.response?.statusCode == 200) {
      if (index != null && _couponModel?.coupons != null && index < _couponModel!.coupons!.length) {
        _couponModel!.coupons![index].status = status ? 1 : 0;
      }
      showCustomSnackBarWidget(getTranslated('coupon_status_update_successfully', Get.context!), Get.context!, isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> deleteCoupon(int? id) async {
    if (id == null) return;
    _isLoading = true;
    notifyListeners();
    final ApiResponse apiResponse = await wholesaleCouponServiceInterface.deleteCoupon(id);
    if (apiResponse.response?.statusCode == 200) {
      await getCouponList(1);
      showCustomSnackBarWidget(getTranslated('coupon_deleted_successfully', Get.context!), Get.context!, isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  void selectDate(String type, BuildContext context) {
    final bool isEnd = type == 'end';
    final DateTime today = DateUtils.dateOnly(DateTime.now());
    final DateTime firstDate = isEnd && startDate != null && startDate!.isAfter(today)
        ? DateUtils.dateOnly(startDate!)
        : today;
    DateTime initialDate = (isEnd ? endDate ?? startDate : startDate) ?? today;
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }

    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2030),
    ).then((date) {
      if (date == null) return;
      if (type == 'start') {
        startDate = date;
        if (endDate != null && endDate!.isBefore(date)) {
          endDate = null;
        }
      } else {
        endDate = date;
      }
      notifyListeners();
    });
  }

  void setSelectedCustomer(int? id, String name) {
    _selectedCustomerId = id ?? 0;
    _selectedCustomerName = name;
    notifyListeners();
  }

  Future<void> getCouponCustomerList(String search) async {
    final int request = ++_requestedCustomerSearch;
    _isCustomerLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleCouponServiceInterface.getCouponCustomerList(search);
    if (request != _requestedCustomerSearch) return;

    if (apiResponse.response?.statusCode == 200) {
      _couponCustomerList = [];
      ApiListEnvelope.fromJson(apiResponse.response!.data).data?.whereType<Map>()
          .forEach((customer) => _couponCustomerList!.add(WholesaleCouponCustomer.fromJson(Map<String, dynamic>.from(customer))));

      if (_selectedCustomerName.isEmpty && _selectedCustomerId != null) {
        for (final WholesaleCouponCustomer customer in _couponCustomerList!) {
          if (customer.id == _selectedCustomerId) {
            _selectedCustomerName = customer.id == 0 ? (getTranslated('all_customer', Get.context!) ?? customer.fullName) : customer.fullName;
            break;
          }
        }
      }
    } else {
      _couponCustomerList ??= [];
      ApiChecker.checkApi(apiResponse);
    }
    _isCustomerLoading = false;
    notifyListeners();
  }
}
