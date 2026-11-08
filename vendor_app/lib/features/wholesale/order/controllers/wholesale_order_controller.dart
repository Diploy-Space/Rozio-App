import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path show join;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/order_details/controllers/order_details_controller.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/models/order_list_filter_model.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/customer_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/domain/models/wholesale_order_details_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/domain/services/wholesale_order_service_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/enums/wholesale_order_setup_step.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/helper/order_helper.dart';
import 'package:sixvalley_vendor_app/helper/validation_helper.dart';
import 'package:sixvalley_vendor_app/interface/order_list_filter_host.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class WholesaleOrderController extends ChangeNotifier implements OrderListFilterHost {
  final WholesaleOrderServiceInterface wholesaleOrderServiceInterface;
  WholesaleOrderController({required this.wholesaleOrderServiceInterface});

  OrderModel? _orderModel;
  OrderModel? get orderModel => _orderModel;

  int _orderTypeIndex = 0;
  int get orderTypeIndex => _orderTypeIndex;

  String _orderType = 'all';
  @override
  String get orderType => _orderType;

  bool _isFilterActive = false;
  bool get isFilterActive => _isFilterActive;

  @override
  OrderListFilterModel filterModel = OrderListFilterModel();

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  DateTime? _startDateFilter;
  DateTime? _endDateFilter;
  @override
  DateTime? get startDateFilter => _startDateFilter;
  @override
  DateTime? get endDateFilter => _endDateFilter;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  @override
  DateFormat get dateFormat => _dateFormat;

  List<WholesaleOrderDetailsModel>? _orderDetails;
  List<WholesaleOrderDetailsModel>? get orderDetails => _orderDetails;

  Order? get order => (_orderDetails?.isNotEmpty ?? false) ? _orderDetails!.first.order : null;

  bool _deliveryVerificationEnabled = false;
  bool get deliveryVerificationEnabled => _deliveryVerificationEnabled;

  List<String> _orderStatusList = [];
  List<String> get orderStatusList => _orderStatusList;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  bool _isInvoiceLoading = false;
  bool get isInvoiceLoading => _isInvoiceLoading;


  @override
  Future<void> getOrderList(BuildContext? context, int offset, String status, OrderListFilterModel? filter, {bool reload = true}) async {
    if(reload) {
      _orderModel = null;
    }
    _isFilterActive = false;
    ApiResponse apiResponse = await wholesaleOrderServiceInterface.getOrderList(offset, status, filter, searchValue: _searchQuery);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final OrderModel result = OrderModel.fromJson(apiResponse.response!.data);
      if(offset == 1 || _orderModel == null) {
        _orderModel = result;
      } else {
        _orderModel!.totalSize = result.totalSize;
        _orderModel!.offset = result.offset;
        _orderModel!.orders!.addAll(result.orders ?? []);
      }

      if(filter != null && ValidationHelper.isOrderFilterApplied(filter)) {
        _isFilterActive = true;
      }
    } else {
      if(offset == 1) {
        _orderModel = OrderModel(orders: []);
      }
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> refreshOrderList() async {
    await getOrderList(null, 1, _orderType, _isFilterActive ? filterModel : null);
  }

  Future<void> setSearchQuery(String query) async {
    if (_searchQuery == query) {
      return;
    }
    _searchQuery = query;
    await refreshOrderList();
  }

  void setIndex(int index, String status, {bool notify = true}) {
    _orderTypeIndex = index;
    _orderType = status;
    resetFilters(refreshOrderList: false, notify: false);
    getOrderList(null, 1, status, null);
    if(notify) {
      notifyListeners();
    }
  }

  @override
  void selectFilterDate(String type, BuildContext context) {
    final bool isEnd = type == 'end';
    final DateTime firstDate = isEnd && _startDateFilter != null ? _startDateFilter! : DateTime(2022);
    final DateTime initialDate = isEnd && _startDateFilter != null
        ? (_endDateFilter != null && !_endDateFilter!.isBefore(_startDateFilter!) ? _endDateFilter! : _startDateFilter!)
        : (type == 'start' && _startDateFilter != null ? _startDateFilter! : DateTime.now());

    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2030),
    ).then((date) {
      if (date == null) return;
      if (type == 'start') {
        _startDateFilter = date;
        filterModel.startDate = date.toString();
        if (_endDateFilter != null && _endDateFilter!.isBefore(date)) {
          _endDateFilter = null;
          filterModel.endDate = null;
        }
      } else {
        _endDateFilter = date;
        filterModel.endDate = date.toString();
      }
      notifyListeners();
    });
  }

  @override
  void resetFilters({bool notify = true, bool refreshOrderList = true}) {
    filterModel = OrderListFilterModel();
    _startDateFilter = null;
    _endDateFilter = null;
    Provider.of<CustomerController>(Get.context!, listen: false).resetCustomerId(isUpdate: true, customerId: -1);
    Provider.of<CartController>(Get.context!, listen: false).emptyCustomerTextField();
    if(refreshOrderList) {
      getOrderList(null, 1, _orderType, null);
    }
    if(notify) {
      notifyListeners();
    }
  }


  Future<void> getOrderDetails(int orderId, {bool reload = true}) async {
    if(reload) {
      _orderDetails = null;
    }
    ApiResponse apiResponse = await wholesaleOrderServiceInterface.getOrderDetails(orderId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final ApiListEnvelope envelope = ApiListEnvelope.fromJson(apiResponse.response!.data);
      _orderDetails = envelope.data?.map((line) => WholesaleOrderDetailsModel.fromJson(line)).toList() ?? [];
      _deliveryVerificationEnabled = envelope.read('delivery_verification_enabled') == true;
      _orderStatusList = OrderHelper.statusListFor(order?.shippingResponsibility);
    } else {
      _orderDetails ??= [];
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void emptyOrderDetails() {
    _orderDetails = null;
    notifyListeners();
  }

  Future<void> getOrderInvoice(int orderId) async {
    _isInvoiceLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await wholesaleOrderServiceInterface.getOrderInvoice(orderId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      await _requestPermissions();
      final downloadsDirectory = Directory('/storage/emulated/0/Download');
      List<int> intList = OrderDetailsController.invoiceBytes(apiResponse.response!.data);

      String fileName = '$orderId.pdf';
      var filePath = path.join(downloadsDirectory.path, fileName);

      int fileCounter = 1;

      while (await File(filePath).exists()) {
        fileName = '$orderId($fileCounter).pdf';
        filePath = path.join(downloadsDirectory.path, fileName);
        fileCounter++;
      }

      final file = File(filePath);
      await file.writeAsBytes(intList);
      await OpenFile.open(filePath);
      showCustomSnackBarWidget(getTranslated('invoice_downloaded_successfully', Get.context!), Get.context!, sanckBarType: SnackBarType.success);
    } else {
      showCustomSnackBarWidget(getTranslated('failed_to_download_invoice', Get.context!), Get.context!, sanckBarType: SnackBarType.error);
    }
    _isInvoiceLoading = false;
    notifyListeners();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }


  static ({double? charge, String? date}) _scheduleChanges(Order order, double? deliverymanCharge, String? expectedDeliveryDate) {
    return (
      charge: (deliverymanCharge != null && deliverymanCharge != (order.deliverymanCharge ?? 0)) ? deliverymanCharge : null,
      date: ((expectedDeliveryDate?.isNotEmpty ?? false) && expectedDeliveryDate != order.expectedDeliveryDate) ? expectedDeliveryDate : null,
    );
  }

  static List<WholesaleOrderSetupStep> changedSetupSteps({
    required Order order,
    String? orderStatus,
    String? paymentStatus,
    int? deliveryManId,
    double? deliverymanCharge,
    String? expectedDeliveryDate,
  }) {
    final schedule = _scheduleChanges(order, deliverymanCharge, expectedDeliveryDate);

    return [
      if (deliveryManId != null && deliveryManId != order.deliveryManId) WholesaleOrderSetupStep.deliveryMan,
      if (schedule.charge != null || schedule.date != null) WholesaleOrderSetupStep.deliverySchedule,
      if (paymentStatus == 'paid' && order.paymentStatus != 'paid') WholesaleOrderSetupStep.payment,
      if (orderStatus != null && orderStatus != order.orderStatus) WholesaleOrderSetupStep.status,
    ];
  }

  Future<void> setUpOrder({
    required Order order,
    required List<WholesaleOrderSetupStep> steps,
    String? orderStatus,
    int? deliveryManId,
    double? deliverymanCharge,
    String? expectedDeliveryDate,
  }) async {
    _isUpdating = true;
    notifyListeners();

    final int orderId = order.id!;
    final schedule = _scheduleChanges(order, deliverymanCharge, expectedDeliveryDate);
    bool isSuccess = true;

    for (final WholesaleOrderSetupStep step in steps) {
      final ApiResponse apiResponse;
      switch (step) {
        case WholesaleOrderSetupStep.deliveryMan:
          apiResponse = await wholesaleOrderServiceInterface.assignDeliveryMan(orderId, deliveryManId!);
        case WholesaleOrderSetupStep.deliverySchedule:
          apiResponse = await wholesaleOrderServiceInterface.updateDeliverySchedule(
            orderId, deliverymanCharge: schedule.charge, expectedDeliveryDate: schedule.date,
          );
        case WholesaleOrderSetupStep.payment:
          apiResponse = await wholesaleOrderServiceInterface.markPaid(orderId);
        case WholesaleOrderSetupStep.status:
          apiResponse = await wholesaleOrderServiceInterface.updateOrderStatus(orderId, orderStatus!);
      }

      if (apiResponse.response == null || apiResponse.response!.statusCode != 200) {
        isSuccess = false;
        ApiChecker.checkApi(apiResponse);
        break;
      }
    }

    if (isSuccess) {
      showCustomSnackBarWidget(getTranslated('updated_successfully', Get.context!), Get.context!, isToaster: true, isError: false, sanckBarType: SnackBarType.success);
    }

    await getOrderDetails(orderId, reload: false);
    refreshOrderList();

    _isUpdating = false;
    notifyListeners();
  }

  Future<void> markPaid(Order order) async {
    await setUpOrder(order: order, steps: [WholesaleOrderSetupStep.payment]);
  }

  Future<void> updateAddress(Order order, {required String addressType, required String contactPersonName, required String phone,
    required String city, required String zip, required String address, required String email}) async {
    final BillingAddressData? currentAddress = addressType == 'billing' ? order.billingAddressData : order.shippingAddressData;

    ApiResponse apiResponse = await wholesaleOrderServiceInterface.updateAddress(
      order.id!,
      addressType: addressType,
      contactPersonName: contactPersonName,
      phone: phone,
      city: city,
      zip: zip,
      email: email,
      address: address,
      latitude: currentAddress?.latitude,
      longitude: currentAddress?.longitude,
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Navigator.of(Get.context!).pop();
      showCustomSnackBarWidget(getTranslated('address_updated_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
      getOrderDetails(order.id!, reload: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }
}
