import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_product_detail_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/domain/services/wholesale_product_details_service_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/enums/wholesale_product_details_tab.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class WholesaleProductDetailsController with ChangeNotifier {
  final WholesaleProductDetailsServiceInterface wholesaleProductDetailsServiceInterface;
  WholesaleProductDetailsController({required this.wholesaleProductDetailsServiceInterface});

  WholesaleProductDetailModel? _product;
  WholesaleProductDetailModel? get product => _product;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isStatusUpdating = false;
  bool get isStatusUpdating => _isStatusUpdating;

  bool _isActive = false;
  bool get isActive => _isActive;

  WholesaleProductDetailsTab _selectedTab = WholesaleProductDetailsTab.overview;
  WholesaleProductDetailsTab get selectedTab => _selectedTab;
  int get selectedTabIndex => WholesaleProductDetailsTab.values.indexOf(_selectedTab);

  bool _isDescriptionExpanded = false;
  bool get isDescriptionExpanded => _isDescriptionExpanded;

  int _selectedAttributeTypeIndex = 0;
  int get selectedAttributeTypeIndex => _selectedAttributeTypeIndex;

  int? _expandedFaqIndex;
  int? get expandedFaqIndex => _expandedFaqIndex;

  List<WholesaleFaq> _faqs = [];
  List<WholesaleFaq> get faqs => _faqs;

  bool _isFaqUpdating = false;
  bool get isFaqUpdating => _isFaqUpdating;

  final Set<int> _faqStatusUpdatingIds = {};
  bool isFaqStatusUpdating(int? faqId) => faqId != null && _faqStatusUpdatingIds.contains(faqId);

  List<String> get attributeTypes {
    final List<String> types = [];
    for (final WholesaleAttributeImage image in _product?.attributeImages ?? const <WholesaleAttributeImage>[]) {
      final String? type = image.attributeType;
      if (type != null && type.isNotEmpty && !types.contains(type)) {
        types.add(type);
      }
    }
    return types;
  }

  String? get selectedAttributeType {
    final List<String> types = attributeTypes;
    if (types.isEmpty) return null;
    return types[_selectedAttributeTypeIndex.clamp(0, types.length - 1)];
  }

  Map<String, List<WholesaleAttributeImage>> get imagesBySelectedAttributeValue {
    final String? type = selectedAttributeType;
    final Map<String, List<WholesaleAttributeImage>> grouped = {};
    if (type == null) return grouped;

    for (final WholesaleAttributeImage image in _product?.attributeImages ?? const <WholesaleAttributeImage>[]) {
      if (image.attributeType != type) continue;
      final String value = image.attributeValue ?? '';
      grouped.putIfAbsent(value, () => []).add(image);
    }
    for (final List<WholesaleAttributeImage> images in grouped.values) {
      images.sort((a, b) => (a.position ?? 0).compareTo(b.position ?? 0));
    }
    return grouped;
  }

  Future<void> getProductDetails(int id, {bool isUpdate = true}) async {
    _product = null;
    _isLoading = true;
    _selectedTab = WholesaleProductDetailsTab.overview;
    _isDescriptionExpanded = false;
    _selectedAttributeTypeIndex = 0;
    _expandedFaqIndex = null;
    _faqs = [];
    if (isUpdate) {
      notifyListeners();
    }

    final ApiResponse apiResponse = await wholesaleProductDetailsServiceInterface.getProductDetails(id);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic data = apiResponse.response!.data;
      final dynamic product = data is Map && data['data'] is Map ? data['data'] : data;
      if (product is Map) {
        _product = WholesaleProductDetailModel.fromJson(Map<String, dynamic>.from(product));
        _isActive = _product?.status == 1;
        _faqs = List<WholesaleFaq>.from(_product?.faqs ?? const <WholesaleFaq>[]);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> toggleStatus(int id) async {
    final bool target = !_isActive;
    _isStatusUpdating = true;
    _isActive = target;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleProductDetailsServiceInterface.updateStatus(id, target);

    final bool isSuccess = apiResponse.response != null && apiResponse.response!.statusCode == 200;
    if (!isSuccess) {
      _isActive = !target;
    }

    _isStatusUpdating = false;
    notifyListeners();

    if (!isSuccess) {
      ApiChecker.checkApi(apiResponse);
    }
    return isSuccess;
  }

  void onChangeTab(int index) {
    _selectedTab = WholesaleProductDetailsTab.values[index];
    notifyListeners();
  }

  void toggleDescription() {
    _isDescriptionExpanded = !_isDescriptionExpanded;
    notifyListeners();
  }

  void onChangeAttributeType(int index) {
    _selectedAttributeTypeIndex = index;
    notifyListeners();
  }

  void toggleFaq(int index) {
    _expandedFaqIndex = _expandedFaqIndex == index ? null : index;
    notifyListeners();
  }

  Future<bool> updateFaq(WholesaleFaq faq, {required List<String> languages, required List<String> questions, required List<String> answers, required int priority}) async {
    if (faq.id == null || languages.isEmpty) return false;
    _isFaqUpdating = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleProductDetailsServiceInterface.updateFaq(faq.id!, languages: languages, questions: questions, answers: answers, priority: priority);
    final bool isSuccess = apiResponse.response != null && apiResponse.response!.statusCode == 200;
    if (isSuccess) {
      final int index = _faqs.indexWhere((item) => item.id == faq.id);
      if (index != -1) {
        _faqs[index] = WholesaleFaq(
          id: faq.id,
          question: questions.first,
          answer: answers.first,
          priority: priority,
          status: faq.status,
          translations: List.generate(languages.length, (i) => WholesaleFaqTranslation(locale: languages[i], question: questions[i], answer: answers[i])),
        );
      }
      showCustomSnackBarWidget(getTranslated('faq_updated_successfully', Get.context!), Get.context!, isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isFaqUpdating = false;
    notifyListeners();
    return isSuccess;
  }

  Future<void> toggleFaqStatus(WholesaleFaq faq) async {
    if (faq.id == null || _faqStatusUpdatingIds.contains(faq.id)) return;
    final bool target = !faq.status;
    _faqStatusUpdatingIds.add(faq.id!);
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleProductDetailsServiceInterface.updateFaqStatus(faq.id!, target);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final int index = _faqs.indexWhere((item) => item.id == faq.id);
      if (index != -1) {
        final WholesaleFaq current = _faqs[index];
        _faqs[index] = WholesaleFaq(id: current.id, question: current.question, answer: current.answer, priority: current.priority, status: target);
      }
      showCustomSnackBarWidget(getTranslated('faq_status_updated_successfully', Get.context!), Get.context!, isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _faqStatusUpdatingIds.remove(faq.id);
    notifyListeners();
  }

  Future<bool> deleteFaq(WholesaleFaq faq) async {
    if (faq.id == null) return false;
    _isFaqUpdating = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleProductDetailsServiceInterface.deleteFaq(faq.id!);
    final bool isSuccess = apiResponse.response != null && apiResponse.response!.statusCode == 200;
    if (isSuccess) {
      _faqs.removeWhere((item) => item.id == faq.id);
      _expandedFaqIndex = null;
      showCustomSnackBarWidget(getTranslated('faq_deleted_successfully', Get.context!), Get.context!, isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isFaqUpdating = false;
    notifyListeners();
    return isSuccess;
  }
}
