import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/domain/models/wholesale_product_rating_summary_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/domain/models/wholesale_product_review_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/domain/services/wholesale_product_review_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class WholesaleProductReviewController with ChangeNotifier {
  final WholesaleProductReviewServiceInterface wholesaleProductReviewServiceInterface;
  WholesaleProductReviewController({required this.wholesaleProductReviewServiceInterface});

  final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isReplyLoading = false;
  bool get isReplyLoading => _isReplyLoading;

  List<WholesaleProductReviewModel>? _reviewList;
  List<WholesaleProductReviewModel>? get reviewList => _reviewList;

  int? _totalSize;
  int? get totalSize => _totalSize;

  int? _offset;
  int? get offset => _offset;

  final Set<int> _statusUpdatingIds = {};
  bool isStatusUpdating(int? reviewId) => reviewId != null && _statusUpdatingIds.contains(reviewId);

  String _searchText = '';
  String get searchText => _searchText;

  void searchReview(String text) {
    if (text.trim() == _searchText) return;
    _searchText = text.trim();
    getReviewList(reload: true);
  }

  Future<void> getReviewList({int offset = 1, bool reload = false}) async {
    if (reload) {
      _reviewList = null;
      notifyListeners();
    }
    _isLoading = true;

    final String requestSearch = _searchText;
    final ApiResponse apiResponse = await wholesaleProductReviewServiceInterface.getReviewList(
      offset: offset,
      search: requestSearch,
      productId: (_appliedProductId != null && _appliedProductId != 0) ? _appliedProductId : null,
      status: _statusValue(_appliedStatusIndex),
      from: _appliedStartDate != null ? _apiDateFormat.format(_appliedStartDate!) : null,
      to: _appliedEndDate != null ? _apiDateFormat.format(_appliedEndDate!) : null,
    );
    if (requestSearch != _searchText) {
      return;
    }

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final ApiListEnvelope envelope = ApiListEnvelope.fromJson(apiResponse.response!.data);
      final List<WholesaleProductReviewModel> reviews = envelope.data
          ?.whereType<Map>().map((review) => WholesaleProductReviewModel.fromJson(Map<String, dynamic>.from(review))).toList() ?? [];

      if (offset == 1 || _reviewList == null) {
        _reviewList = reviews;
      } else {
        _reviewList!.addAll(reviews);
      }
      _totalSize = envelope.totalSize;
      _offset = envelope.offset ?? offset;
    } else {
      _reviewList ??= [];
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  List<WholesaleProductReviewModel>? _productReviews;
  List<WholesaleProductReviewModel>? get productReviews => _productReviews;

  WholesaleProductRatingSummaryModel? _productRatingSummary;
  WholesaleProductRatingSummaryModel? get productRatingSummary => _productRatingSummary;

  Future<void> getProductReviews(int productId) async {
    _productReviews = null;
    _productRatingSummary = null;
    final ApiResponse apiResponse = await wholesaleProductReviewServiceInterface.getReviewList(offset: 1, productId: productId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final ApiListEnvelope envelope = ApiListEnvelope.fromJson(apiResponse.response!.data);
      _productReviews = envelope.data
          ?.whereType<Map>().map((review) => WholesaleProductReviewModel.fromJson(Map<String, dynamic>.from(review))).toList() ?? [];
      _productRatingSummary = WholesaleProductRatingSummaryModel.fromJson(Map<String, dynamic>.from(envelope.content));
    } else {
      _productReviews = [];
    }
    notifyListeners();
  }

  static int? _statusValue(int statusIndex) {
    if (statusIndex == 1) return 1;
    if (statusIndex == 2) return 0;
    return null;
  }

  final List<String> reviewStatusList = ['select_status', 'active', 'inactive'];

  int _filterStatusIndex = 0;
  int get filterStatusIndex => _filterStatusIndex;
  void setFilterStatusIndex(int index) {
    _filterStatusIndex = index;
    notifyListeners();
  }

  int? _filterProductId;
  int? get filterProductId => _filterProductId;
  String _filterProductName = 'Select Product';
  String get filterProductName => _filterProductName;
  void setFilterProduct(int? productId, String? productName) {
    _filterProductId = productId;
    _filterProductName = productName ?? 'Select Product';
    notifyListeners();
  }

  DateTime? _filterStartDate;
  DateTime? get filterStartDate => _filterStartDate;
  DateTime? _filterEndDate;
  DateTime? get filterEndDate => _filterEndDate;
  final DateFormat dateFormat = DateFormat('d MMM, yyyy');

  void selectDate(String type, BuildContext context) {
    final bool isEnd = type == 'end';
    final DateTime firstDate = isEnd && _filterStartDate != null ? _filterStartDate! : DateTime(2022);
    final DateTime initialDate = isEnd && _filterStartDate != null
        ? (_filterEndDate != null && !_filterEndDate!.isBefore(_filterStartDate!) ? _filterEndDate! : _filterStartDate!)
        : (type == 'start' && _filterStartDate != null ? _filterStartDate! : DateTime.now());

    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2030),
    ).then((date) {
      if (date == null) return;
      if (type == 'start') {
        _filterStartDate = date;
        if (_filterEndDate != null && _filterEndDate!.isBefore(date)) {
          _filterEndDate = null;
        }
      } else {
        _filterEndDate = date;
      }
      notifyListeners();
    });
  }

  int _appliedStatusIndex = 0;
  int get appliedStatusIndex => _appliedStatusIndex;

  int? _appliedProductId;
  int? get appliedProductId => _appliedProductId;
  String _appliedProductName = 'Select Product';

  DateTime? _appliedStartDate;
  DateTime? get appliedStartDate => _appliedStartDate;

  DateTime? _appliedEndDate;
  DateTime? get appliedEndDate => _appliedEndDate;

  int get appliedFilterCount =>
      (_appliedStatusIndex != 0 ? 1 : 0) +
      (_appliedProductId != null && _appliedProductId != 0 ? 1 : 0) +
      (_appliedStartDate != null ? 1 : 0);

  void initFilterData() {
    _filterStatusIndex = _appliedStatusIndex;
    _filterProductId = _appliedProductId;
    _filterProductName = _appliedProductName;
    _filterStartDate = _appliedStartDate;
    _filterEndDate = _appliedEndDate;
  }

  bool applyFilter(BuildContext context) {
    if (_filterStartDate == null && _filterEndDate == null && _filterStatusIndex == 0 && (_filterProductId == null || _filterProductId == 0)) {
      showCustomToast(message: getTranslated('select_all_fields', context)!, context: context, isSuccess: false);
      return false;
    }
    if ((_filterStartDate != null && _filterEndDate == null) || (_filterStartDate == null && _filterEndDate != null)) {
      showCustomToast(message: getTranslated('select_start_and_end_time', context)!, context: context, isSuccess: false);
      return false;
    }
    if (_filterStartDate != null && _filterEndDate != null && _filterEndDate!.isBefore(_filterStartDate!)) {
      showCustomToast(message: getTranslated('end_date_should_not_before_start_date', context)!, context: context, isSuccess: false);
      return false;
    }
    _appliedStatusIndex = _filterStatusIndex;
    _appliedProductId = _filterProductId;
    _appliedProductName = _filterProductName;
    _appliedStartDate = _filterStartDate;
    _appliedEndDate = _filterEndDate;
    getReviewList(reload: true);
    return true;
  }

  void clearFilterData() {
    _resetFilters();
    getReviewList(reload: true);
  }

  void resetForNewVisit() {
    _resetFilters();
    _searchText = '';
    _reviewList = null;
  }

  void _resetFilters() {
    _filterStatusIndex = 0;
    _filterProductId = null;
    _filterProductName = 'Select Product';
    _filterStartDate = null;
    _filterEndDate = null;
    _appliedStatusIndex = 0;
    _appliedProductId = null;
    _appliedProductName = 'Select Product';
    _appliedStartDate = null;
    _appliedEndDate = null;
  }

  Future<void> toggleReviewStatus(WholesaleProductReviewModel review) async {
    if (review.id == null || _statusUpdatingIds.contains(review.id)) return;
    final int newStatus = review.status == 1 ? 0 : 1;

    _statusUpdatingIds.add(review.id!);
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleProductReviewServiceInterface.updateStatus(review.id!, newStatus == 1);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      review.status = newStatus;
      showCustomSnackBarWidget(getTranslated('review_status_updated_successfully', Get.context!), Get.context!, isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _statusUpdatingIds.remove(review.id);
    notifyListeners();
  }

  final TextEditingController replyController = TextEditingController();
  void emptyReplyText() => replyController.text = '';

  Future<void> sendReply(BuildContext context, WholesaleProductReviewModel review) async {
    final String replyText = replyController.text.trim();
    if (replyText.isEmpty) {
      showCustomSnackBarWidget(getTranslated('write_a_review_reply', context), context, sanckBarType: SnackBarType.warning);
      return;
    }
    if (review.id == null || _isReplyLoading) return;

    _isReplyLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleProductReviewServiceInterface.sendReply(review.id!, replyText);
    final int? statusCode = apiResponse.response?.statusCode;
    if (statusCode == 200 || statusCode == 201) {
      review.reply = WholesaleReviewReply(replyText: replyText, addedBy: 'seller', createdAt: review.reply?.createdAt ?? DateTime.now().toIso8601String());
      showCustomSnackBarWidget(getTranslated('reply_added_successfully', Get.context!), Get.context!, isError: false);
      Navigator.of(Get.context!).pop();
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isReplyLoading = false;
    notifyListeners();
  }
}
