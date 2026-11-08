import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_details_model.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/services/refund_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';

class RefundController extends ChangeNotifier {
  final RefundServiceInterface refundServiceInterface;
  RefundController({required this.refundServiceInterface});


  List<RefundModel>? _refundList;
  List<RefundModel>? get refundList => _refundList;

  int? _refundTotalSize;
  int? get refundTotalSize => _refundTotalSize;

  int? _refundOffset;
  int? get refundOffset => _refundOffset;

  String? _dateType = 'all';
  String? _startDate;
  String? _endDate;

  static const List<String?> _tabStatuses = [null, AppConstants.pending, AppConstants.approved, AppConstants.rejected, AppConstants.done];

  RefundModel? _refundModel;
  RefundModel? get refundModel => _refundModel;


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _refundTypeIndex = 0;
  int get refundTypeIndex => _refundTypeIndex;

  final List<String> _refundStatusList = [];
  String _refundStatusType = '';
  List<String> get refundStatusList => _refundStatusList;
  String get refundStatusType => _refundStatusType;

  RefundDetailsModel? _refundDetailsModel;
  RefundDetailsModel? get refundDetailsModel => _refundDetailsModel;
  final bool _isSendButtonActive = false;
  bool get isSendButtonActive => _isSendButtonActive;
  final bool _adminReplied = true;
  bool get adminReplied => _adminReplied;

  bool _showRejectButton = false;
  bool get showRejectButton => _showRejectButton;


  bool?_isFilterActive = false;
  bool? get isFilterActive => _isFilterActive;



  Future<ApiResponse> updateRefundStatus(BuildContext context,int? id, String status, String note) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse;
    apiResponse = await refundServiceInterface.refundStatus(id, status, note);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBarWidget(getTranslated('successfully_updated_refund_status', Get.context!), Get.context!,isError: false);
      _isLoading = false;
      if(status == 'approved'){
        _refundTypeIndex = 1;
      } else if(status == 'rejected') {
        _refundTypeIndex = 2;
      }
    } else {
      Navigator.of(Get.context!).pop();
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


  Future<ApiResponse> getRefundReqInfo(BuildContext context, int? refundId) async {
    _isLoading = true;

    ApiResponse apiResponse = await refundServiceInterface.getRefundReqDetails(refundId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _refundDetailsModel = RefundDetailsModel.fromJson(Map<String, dynamic>.from(ApiEnvelope.dataObject(apiResponse.response!.data)));

      if(refundDetailsModel?.refundRequest != null && refundDetailsModel!.refundRequest!.isNotEmpty) {
        setShowResetButton(refundDetailsModel?.refundRequest![0].refundStatus);
      }
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<void> getRefundList(BuildContext context, {bool isReload = false, String? type = 'all', String? startDate, String? endDate, int offset = 1}) async {
    if(offset == 1) {
      _dateType = type;
      _startDate = startDate;
      _endDate = endDate;
    }

    if(isReload) {
      _refundList = null;
      notifyListeners();
    }

    final int tabIndex = _refundTypeIndex;
    ApiResponse apiResponse = await refundServiceInterface.getRefundList(_dateType, _startDate, _endDate, _tabStatuses[tabIndex], offset);
    final bool isSuccess = apiResponse.response != null && apiResponse.response!.statusCode == 200;

    ApiListEnvelope? envelope;
    List<RefundModel> refunds = [];
    if (isSuccess) {
      envelope = ApiListEnvelope.fromJson(apiResponse.response!.data);
      refunds = envelope.data?.map((refund) => RefundModel.fromJson(refund)).toList() ?? [];
      await _getRefundedProductFromOrderDetails(refunds);
    }

    if(tabIndex != _refundTypeIndex) {
      return;
    }

    if (isSuccess) {
      if(offset == 1 || _refundList == null) {
        _refundList = refunds;
      } else {
        _refundList!.addAll(refunds);
      }
      _refundTotalSize = envelope!.totalSize;
      _refundOffset = envelope.offset;
    } else {
      _refundList ??= [];
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> _getRefundedProductFromOrderDetails(List<RefundModel> refunds) async {
    final Map<int, List<RefundModel>> refundsByOrder = {};
    for (final RefundModel refund in refunds) {
      if (refund.product == null && refund.orderId != null) {
        refundsByOrder.putIfAbsent(refund.orderId!, () => []).add(refund);
      }
    }

    await Future.wait(refundsByOrder.entries.map((entry) async {
      final ApiResponse apiResponse = await refundServiceInterface.getRefundedProductFromOrderDetails(entry.key);
      final dynamic data = apiResponse.response?.data;
      if (apiResponse.response?.statusCode != 200 || data is! Map) {
        return;
      }

      final List lines = ApiListEnvelope.fromJson(Map<String, dynamic>.from(data)).data ?? [];
      for (final RefundModel refund in entry.value) {
        final dynamic line = lines.firstWhere((line) => line is Map && line['id'] == refund.orderDetailsId, orElse: () => null);
        if (line is Map) {
          refund.product = Product.fromOrderDetailsSnapshot(line['product_details']);
        }
      }
    }));
  }

  Future<void> reloadRefundList() async {
    await getRefundList(Get.context!, isReload: true, type: _dateType, startDate: _startDate, endDate: _endDate);
  }


  void setIndex(int index) {
    _refundTypeIndex = index;
    reloadRefundList();
  }

  void updateStatus(String value) {
    _refundStatusType = value;
    notifyListeners();
  }

  void setShowResetButton(List<RefundStatus>? refundStatus) {
    List<RefundStatus>? status = refundStatus;

    String changeBy = '';
    for(RefundStatus action in status!){
      if(action.changeBy == 'admin'){
        changeBy = 'admin';
        _showRejectButton = false;
      }
    }

    if(changeBy != 'admin'){
      _showRejectButton = true;
    }
  }

  void setInitialResetButton() {
    _showRejectButton = false;
  }

  void emptyRefundModel() {
    _refundModel = null;
  }


  Future<ApiResponse> getSingleRefundModel(BuildContext context, int? refundId) async {
    _isLoading = true;

    ApiResponse apiResponse = await refundServiceInterface.getSingleRefundModel(refundId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final RefundModel refund = RefundModel.fromJson(Map<String, dynamic>.from(ApiEnvelope.dataObject(apiResponse.response!.data)));
      await _getRefundedProductFromOrderDetails([refund]);
      _refundModel = refund;
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  void emptyRefundDetailsModel() {
    _refundDetailsModel = null;
  }

  void setFilterActive(bool value, {bool isUpdate = true}) {
    _isFilterActive = value;
    if(isUpdate) {
      notifyListeners();
    }
  }

}
