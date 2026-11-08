import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/coupon/domain/models/coupon_model.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/customer_model.dart';
import 'package:sixvalley_vendor_app/features/coupon/domain/services/coupon_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';

class CouponController with ChangeNotifier {
  final CouponServiceInterface couponServiceInterface;

  CouponController({required this.couponServiceInterface});

  CouponModel? _couponModel;
  CouponModel? get couponModel => _couponModel;
  List<Customers>? _couponCustomerList;
  List<Customers>? get couponCustomerList => _couponCustomerList;
  final List<int?> _couponCustomerIds = [];
  List<int?> get couponCustomerIds => _couponCustomerIds;
  int? _couponCustomerIndex = 0;
  int? get couponCustomerIndex => _couponCustomerIndex;
  int? _selectedCustomerIdForCoupon;
  int? get selectedCustomerIdForCoupon => _selectedCustomerIdForCoupon;
  final TextEditingController _searchCustomerController =
      TextEditingController();
  TextEditingController get searchCustomerController =>
      _searchCustomerController;
  String _customerSelectedName = '';
  String get customerSelectedName => _customerSelectedName;
  final String _customerSelectedMobile = '';
  String get customerSelectedMobile => _customerSelectedMobile;
  int? _customerId = 0;
  int? get customerId => _customerId;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isAdd = false;
  bool get isAdd => _isAdd;
  String? _selectedCouponType;
  String? get selectedCouponType => _selectedCouponType;
  final List<String> _couponTypeList = [
    'discount_on_purchase',
    'free_delivery'
  ];
  List<String> get couponTypeList => _couponTypeList;
  String? _discountTypeName = 'amount';
  String? get discountTypeName => _discountTypeName;
  List<String> discountTypeList = ['amount', 'percentage'];
  DateTime? startDate;
  DateTime? endDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateFormat get dateFormat => _dateFormat;

  void setSelectedCouponType(String? type) {
    _selectedCouponType = type;
    notifyListeners();
  }

  void setSelectedDiscountNameType(String? type) {
    _discountTypeName = type;
    notifyListeners();
  }

  Future<void> getCouponList(BuildContext context, int offset,
      {bool reload = true}) async {
    ApiResponse apiResponse =
        await couponServiceInterface.getCouponList(offset);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (offset == 1) {
        _couponModel = null;
        _couponModel = CouponModel.fromJson(apiResponse.response!.data);
      } else {
        _couponModel!.totalSize =
            CouponModel.fromJson(apiResponse.response!.data).totalSize;
        _couponModel!.offset =
            CouponModel.fromJson(apiResponse.response!.data).offset;
        _couponModel!.coupons!
            .addAll(CouponModel.fromJson(apiResponse.response!.data).coupons!);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNewCoupon(
      BuildContext context, Coupons coupons, bool update) async {
    _isAdd = true;
    ApiResponse apiResponse =
        await couponServiceInterface.addNewCoupon(coupons, update: update);
    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201)) {
      getCouponList(Get.context!, 1);
      _isAdd = false;
      startDate = null;
      endDate = null;
      Navigator.pop(Get.context!);
      update
          ? showCustomSnackBarWidget(
              getTranslated('coupon_updated_successfully', Get.context!),
              Get.context!,
              isError: false)
          : showCustomSnackBarWidget(
              getTranslated('coupon_added_successfully', Get.context!),
              Get.context!,
              isError: false);
    } else {
      _isAdd = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> updateCouponStatus(
      BuildContext context, int? id, int status, index) async {
    ApiResponse response =
        await couponServiceInterface.updateCouponStatus(id, status);
    if (response.response!.statusCode == 200) {
      _couponModel!.coupons![index].status = status;
      showCustomSnackBarWidget(
          getTranslated('coupon_status_update_successfully', Get.context!),
          Get.context!,
          isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }

  Future<void> deleteCoupon(BuildContext context, int? id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await couponServiceInterface.deleteCoupon(id);
    if (apiResponse.response!.statusCode == 200) {
      await getCouponList(Get.context!, 1, reload: true);
      showCustomSnackBarWidget(
          getTranslated('coupon_deleted_successfully', Get.context!),
          Get.context!,
          isError: false);
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

  void setCouponCustomerIndex(int index, int customerId, bool notify) {
    _couponCustomerIndex = index;
    _selectedCustomerIdForCoupon = customerId;
    if (notify) {
      notifyListeners();
    }
  }

  void setCustomerInfo(int? id, String name, bool notify) {
    _customerId = id;
    _customerSelectedName = name;
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> getCouponCustomerList(
      BuildContext context, String search) async {
    _isLoading = true;
    ApiResponse response =
        await couponServiceInterface.getCouponCustomerList(search);
    if (response.response!.statusCode == 200) {
      _isLoading = false;
      _couponCustomerList = [];
      ApiListEnvelope.fromJson(response.response!.data, legacyKeys: [
        'customers'
      ]).data?.forEach(
          (customer) => _couponCustomerList!.add(Customers.fromJson(customer)));
      _couponCustomerIds.clear();
      if (_couponCustomerList!.isNotEmpty) {
        for (int index = 0; index < _couponCustomerList!.length; index++) {
          _couponCustomerIds.add(_couponCustomerList![index].id);
        }
        _couponCustomerIndex = _couponCustomerIds[0];
      }
      if (_customerSelectedName.isEmpty) {
        _matchSelectedCustomerName();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearCouponData() {
    startDate = null;
    endDate = null;
    _couponCustomerIndex = 0;
    _selectedCustomerIdForCoupon = null;
    _customerId = 0;
    _customerSelectedName = '';
    _searchCustomerController.clear();
    _selectedCouponType = null;
    _discountTypeName = 'amount';
  }

  void initCouponCustomer(int? customerId) {
    _selectedCustomerIdForCoupon = customerId ?? 0;
    _customerSelectedName = '';
    _searchCustomerController.clear();
    if (_selectedCustomerIdForCoupon == 0) {
      _customerSelectedName = getTranslated('all_customer', Get.context!) ?? '';
      _searchCustomerController.text = _customerSelectedName;
    } else {
      _matchSelectedCustomerName();
    }
  }

  void _matchSelectedCustomerName() {
    if (_selectedCustomerIdForCoupon == null) return;
    for (final Customers customer in _couponCustomerList ?? []) {
      if (customer.id == _selectedCustomerIdForCoupon) {
        _customerSelectedName = customer.id == 0
            ? (getTranslated('all_customer', Get.context!) ?? '')
            : '${customer.fName ?? ''} ${customer.lName ?? ''}'.trim();
        _searchCustomerController.text = _customerSelectedName;
        break;
      }
    }
  }

  void initCouponTypes(String? couponType, String? discountType) {
    _selectedCouponType = _couponTypeList.contains(couponType)
        ? couponType
        : 'discount_on_purchase';
    _discountTypeName =
        discountTypeList.contains(discountType) ? discountType : 'amount';
  }
}
