import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_details_model.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/domain/services/wholesale_refund_service_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/enums/wholesale_refund_status.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class WholesaleRefundController with ChangeNotifier {
  final WholesaleRefundServiceInterface wholesaleRefundServiceInterface;
  WholesaleRefundController({required this.wholesaleRefundServiceInterface});

  static const List<WholesaleRefundStatus?> statusTabs = [
    null,
    WholesaleRefundStatus.pending,
    WholesaleRefundStatus.approved,
    WholesaleRefundStatus.rejected,
    WholesaleRefundStatus.refunded,
  ];

  final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');

  List<RefundModel>? _refundList;
  List<RefundModel>? get refundList => _refundList;

  int? _totalSize;
  int? get totalSize => _totalSize;

  int? _offset;
  int? get offset => _offset;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  String? _dateType;
  String? get dateType => _dateType;

  DateTime? _startDate;
  DateTime? _endDate;

  bool get isFilterActive => _dateType != null;

  RefundDetailsModel? _refundDetails;
  RefundDetailsModel? get refundDetails => _refundDetails;

  RefundModel? _refund;
  RefundModel? get refund => _refund;

  bool _isDetailsLoading = false;
  bool get isDetailsLoading => _isDetailsLoading;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;


  Future<void> getRefundList({int offset = 1, bool reload = false}) async {
    if(reload) {
      _refundList = null;
      notifyListeners();
    }

    final int tabIndex = _tabIndex;
    final ApiResponse apiResponse = await wholesaleRefundServiceInterface.getRefundList(
      offset: offset,
      status: statusTabs[tabIndex]?.value,
      dateType: _dateType,
      startDate: _startDate != null ? _apiDateFormat.format(_startDate!) : null,
      endDate: _endDate != null ? _apiDateFormat.format(_endDate!) : null,
    );
    if(tabIndex != _tabIndex) {
      return;
    }

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final ApiListEnvelope envelope = ApiListEnvelope.fromJson(apiResponse.response!.data);
      final List<RefundModel> refunds = envelope.data?.map((refund) => RefundModel.fromJson(refund)).toList() ?? [];

      if(offset == 1 || _refundList == null) {
        _refundList = refunds;
      } else {
        _refundList!.addAll(refunds);
      }
      _totalSize = envelope.totalSize;
      _offset = envelope.offset;
    } else {
      _refundList ??= [];
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void setIndex(int index) {
    _tabIndex = index;
    getRefundList(reload: true);
  }

  void setDateFilter(String? dateType, {DateTime? startDate, DateTime? endDate}) {
    _dateType = dateType;
    _startDate = dateType == 'custom_date' ? startDate : null;
    _endDate = dateType == 'custom_date' ? endDate : null;
    getRefundList(reload: true);
  }


  Future<void> getRefundDetails(int refundId, {bool reload = true}) async {
    if(reload) {
      _refundDetails = null;
      _refund = null;
    }
    _isDetailsLoading = true;

    final List<ApiResponse> responses = await Future.wait([
      wholesaleRefundServiceInterface.getRefundDetails(refundId),
      wholesaleRefundServiceInterface.getRefundOrderItem(refundId),
    ]);
    final ApiResponse detailsResponse = responses[0];
    final ApiResponse orderItemResponse = responses[1];

    if (detailsResponse.response != null && detailsResponse.response!.statusCode == 200) {
      _refundDetails = RefundDetailsModel.fromJson(Map<String, dynamic>.from(ApiEnvelope.dataObject(detailsResponse.response!.data)));
    } else {
      ApiChecker.checkApi(detailsResponse);
    }

    if (orderItemResponse.response != null && orderItemResponse.response!.statusCode == 200) {
      _refund = RefundModel.fromJson(Map<String, dynamic>.from(ApiEnvelope.dataObject(orderItemResponse.response!.data)));
    } else if (detailsResponse.response?.statusCode == 200) {
      ApiChecker.checkApi(orderItemResponse);
    }

    _isDetailsLoading = false;
    notifyListeners();
  }

  void emptyRefundDetails() {
    _refundDetails = null;
    _refund = null;
  }

  List<RefundStatus> get statusHistory {
    final List<RefundRequest>? requests = _refundDetails?.refundRequest;
    return (requests != null && requests.isNotEmpty) ? (requests.first.refundStatus ?? []) : [];
  }

  WholesaleRefundStatus? get currentStatus {
    final List<RefundRequest>? requests = _refundDetails?.refundRequest;
    final String? status = (requests != null && requests.isNotEmpty) ? requests.first.status : _refund?.status;
    return status != null ? WholesaleRefundStatus.fromString(status) : null;
  }

  bool get isLockedByAdmin => statusHistory.isNotEmpty && statusHistory.last.changeBy == 'admin';


  Future<bool> updateRefundStatus(RefundModel refund, WholesaleRefundStatus status, String note) async {
    _isUpdating = true;
    notifyListeners();

    final bool isReject = status == WholesaleRefundStatus.rejected;
    final ApiResponse apiResponse = await wholesaleRefundServiceInterface.updateRefundStatus(
      refund.id!,
      refundStatus: status.value,
      paymentInfo: refund.order?.paymentMethod ?? '',
      approvedNote: isReject ? null : note,
      rejectedNote: isReject ? note : null,
    );

    final bool isSuccess = apiResponse.response != null && apiResponse.response!.statusCode == 200;
    if (isSuccess) {
      showCustomSnackBarWidget(getTranslated('successfully_updated_refund_status', Get.context!), Get.context!, isError: false);
      await getRefundDetails(refund.id!, reload: false);
      getRefundList(reload: true);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isUpdating = false;
    notifyListeners();
    return isSuccess;
  }
}
