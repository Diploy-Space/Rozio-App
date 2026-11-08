import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/pagination_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/domain/models/wholesale_product_list_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/domain/services/wholesale_product_list_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';

class WholesaleProductListController with ChangeNotifier {
  final WholesaleProductListServiceInterface wholesaleProductListServiceInterface;
  WholesaleProductListController({required this.wholesaleProductListServiceInterface});

  static const int _limit = 20;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  List<WholesaleProductListModel>? _products;
  List<WholesaleProductListModel>? get products => _products;

  PaginationModel? _pagination;
  PaginationModel? get pagination => _pagination;

  int _offset = 1;
  int get offset => _offset;

  bool get hasNextPage => _pagination?.hasNextPage ?? false;

  String _state = 'all';
  String get state => _state;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int _filterSortIndex = 0;
  int get filterSortIndex => _filterSortIndex;
  void setFilterSortIndex(int index) {
    _filterSortIndex = index;
    notifyListeners();
  }

  final Set<int> _selectedProductStatuses = {};
  Set<int> get selectedProductStatuses => _selectedProductStatuses;
  void onChangeProductStatus(int status, {bool isUpdate = true}) {
    if (_selectedProductStatuses.contains(status)) {
      _selectedProductStatuses.remove(status);
    } else {
      _selectedProductStatuses.add(status);
    }
    if (isUpdate) {
      notifyListeners();
    }
  }

  final Set<int> _selectedBrandIds = {};
  Set<int> get selectedBrandIds => _selectedBrandIds;
  void onChangeBrandIds(int id, {bool isUpdate = true}) {
    if (_selectedBrandIds.contains(id)) {
      _selectedBrandIds.remove(id);
    } else {
      _selectedBrandIds.add(id);
    }
    if (isUpdate) {
      notifyListeners();
    }
  }
  void onClearBrandIds() {
    _selectedBrandIds.clear();
    notifyListeners();
  }

  final Set<int> _selectedCategoryIds = {};
  Set<int> get selectedCategoryIds => _selectedCategoryIds;

  final Set<int> _selectedSubCategoryIds = {};
  Set<int> get selectedSubCategoryIds => _selectedSubCategoryIds;

  final Set<int> _selectedSubSubCategoryIds = {};
  Set<int> get selectedSubSubCategoryIds => _selectedSubSubCategoryIds;

  void onChangeCategoryId(int id) {
    _toggle(_selectedCategoryIds, id);
    notifyListeners();
  }

  void onChangeSubCategoryId(int id) {
    _toggle(_selectedSubCategoryIds, id);
    notifyListeners();
  }

  void onChangeSubSubCategoryId(int id) {
    _toggle(_selectedSubSubCategoryIds, id);
    notifyListeners();
  }

  void _toggle(Set<int> ids, int id) {
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
  }

  final Set<int> _expandedCategoryIds = {};
  Set<int> get expandedCategoryIds => _expandedCategoryIds;
  void toggleCategoryExpanded(int id) {
    _toggle(_expandedCategoryIds, id);
    notifyListeners();
  }

  final Set<int> _expandedSubCategoryIds = {};
  Set<int> get expandedSubCategoryIds => _expandedSubCategoryIds;
  void toggleSubCategoryExpanded(int id) {
    _toggle(_expandedSubCategoryIds, id);
    notifyListeners();
  }

  bool _brandSeeMore = false;
  bool get brandSeeMore => _brandSeeMore;
  void toggleBrandSeeMore() {
    _brandSeeMore = !_brandSeeMore;
    notifyListeners();
  }

  bool _categorySeeMore = false;
  bool get categorySeeMore => _categorySeeMore;
  void toggleCategorySeeMore() {
    _categorySeeMore = !_categorySeeMore;
    notifyListeners();
  }

  int _appliedSortIndex = 0;
  int get appliedSortIndex => _appliedSortIndex;

  Set<int> _appliedProductStatuses = {};
  Set<int> _appliedBrandIds = {};
  Set<int> _appliedCategoryIds = {};
  Set<int> _appliedSubCategoryIds = {};
  Set<int> _appliedSubSubCategoryIds = {};

  Set<int> get appliedBrandIds => _appliedBrandIds;
  Set<int> get appliedCategoryIds => _appliedCategoryIds;

  int get appliedFilterCount =>
      _appliedProductStatuses.length +
      _appliedBrandIds.length +
      _appliedCategoryIds.length +
      _appliedSubCategoryIds.length +
      _appliedSubSubCategoryIds.length +
      (_appliedSortIndex != 0 ? 1 : 0);

  void initFilterData() {
    _filterSortIndex = _appliedSortIndex;
    _selectedProductStatuses..clear()..addAll(_appliedProductStatuses);
    _selectedBrandIds..clear()..addAll(_appliedBrandIds);
    _selectedCategoryIds..clear()..addAll(_appliedCategoryIds);
    _selectedSubCategoryIds..clear()..addAll(_appliedSubCategoryIds);
    _selectedSubSubCategoryIds..clear()..addAll(_appliedSubSubCategoryIds);
  }

  Future<void> applyFilter() async {
    _appliedSortIndex = _filterSortIndex;
    _appliedProductStatuses = Set.of(_selectedProductStatuses);
    _appliedBrandIds = Set.of(_selectedBrandIds);
    _appliedCategoryIds = Set.of(_selectedCategoryIds);
    _appliedSubCategoryIds = Set.of(_selectedSubCategoryIds);
    _appliedSubSubCategoryIds = Set.of(_selectedSubSubCategoryIds);
    await getProductList(offset: 1, reload: true);
  }

  Future<void> clearFilterData({bool refresh = true, bool notify = true}) async {
    _filterSortIndex = 0;
    _selectedProductStatuses.clear();
    _selectedBrandIds.clear();
    _selectedCategoryIds.clear();
    _selectedSubCategoryIds.clear();
    _selectedSubSubCategoryIds.clear();
    _expandedCategoryIds.clear();
    _expandedSubCategoryIds.clear();
    _brandSeeMore = false;
    _categorySeeMore = false;

    _appliedSortIndex = 0;
    _appliedProductStatuses = {};
    _appliedBrandIds = {};
    _appliedCategoryIds = {};
    _appliedSubCategoryIds = {};
    _appliedSubSubCategoryIds = {};

    if (refresh) {
      await getProductList(offset: 1, reload: true);
    } else if (notify) {
      notifyListeners();
    }
  }

  void resetForNewVisit() {
    _state = 'all';
    _searchQuery = '';
    clearFilterData(refresh: false, notify: false);
  }

  bool get hasActiveQuery => _state != 'all' || _searchQuery.isNotEmpty || appliedFilterCount > 0;

  String? get _sortValue {
    switch (_appliedSortIndex) {
      case 0:
        return 'latest';
      case 1:
        return 'oldest';
      case 2:
        return 'best-selling';
      case 3:
        return 'most-favorite';
      default:
        return null;
    }
  }

  Future<void> setTabState(String state) async {
    if (_state == state) {
      return;
    }
    _state = state;
    await getProductList(offset: 1, reload: true);
  }

  Future<void> setSearchQuery(String query) async {
    if (_searchQuery == query) {
      return;
    }
    _searchQuery = query;
    await getProductList(offset: 1, reload: true);
  }

  Future<void> getProductList({required int offset, bool reload = false, bool isUpdate = true}) async {
    if (offset == 1) {
      _offset = 1;
      if (reload) {
        _products = null;
      }
      _isLoading = true;
    } else {
      if (_isLoadingMore || !hasNextPage) {
        return;
      }
      _isLoadingMore = true;
    }
    if (isUpdate) {
      notifyListeners();
    }

    final ApiResponse apiResponse = await wholesaleProductListServiceInterface.getProductList(
      offset: offset,
      limit: _limit,
      state: _state,
      search: _searchQuery,
      sortBy: _sortValue,
      productStatus: _appliedProductStatuses.toList(),
      brandIds: _appliedBrandIds.toList(),
      categoryIds: _appliedCategoryIds.toList(),
      subCategoryIds: _appliedSubCategoryIds.toList(),
      subSubCategoryIds: _appliedSubSubCategoryIds.toList(),
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final WholesaleProductListResponseModel data = WholesaleProductListResponseModel.fromJson(apiResponse.response!.data);

      if (offset == 1) {
        _products = data.products;
      } else {
        _products ??= [];
        _products!.addAll(data.products);
      }

      _pagination = data.pagination;
      _offset = data.pagination?.currentPage ?? offset;
    } else {
      if (offset == 1) {
        _products = [];
      }
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  final Set<int> _deletingProductIds = {};
  bool isDeleting(int? productId) => productId != null && _deletingProductIds.contains(productId);

  Future<bool> deleteProduct(BuildContext context, int? productId) async {
    if (productId == null || _deletingProductIds.contains(productId)) {
      return false;
    }

    _deletingProductIds.add(productId);
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleProductListServiceInterface.deleteProduct(productId);

    bool isSuccess = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _products?.removeWhere((product) => product.id == productId);
      if (_pagination?.total != null) {
        _pagination!.total = _pagination!.total! - 1;
      }
      isSuccess = true;

      if (context.mounted) {
        showCustomSnackBarWidget(
          apiResponse.response?.data['message'] ?? getTranslated('product_deleted_successfully', context),
          context,
          isError: false,
        );
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _deletingProductIds.remove(productId);
    notifyListeners();
    return isSuccess;
  }

  final Set<int> _statusUpdatingProductIds = {};
  bool isUpdatingStatus(int? productId) => productId != null && _statusUpdatingProductIds.contains(productId);

  Future<bool> toggleProductStatus(BuildContext context, WholesaleProductListModel product) async {
    final int? productId = product.id;
    if (productId == null || _statusUpdatingProductIds.contains(productId)) {
      return false;
    }

    final bool newStatus = !product.isActive;

    _statusUpdatingProductIds.add(productId);
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleProductListServiceInterface.updateProductStatus(productId, newStatus);

    bool isSuccess = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final int index = _products?.indexWhere((item) => item.id == productId) ?? -1;
      if (index != -1) {
        _products![index] = _products![index].copyWithStatus(newStatus ? 1 : 0);
      }
      isSuccess = true;

      if (context.mounted) {
        showCustomSnackBarWidget(
          apiResponse.response?.data['message'] ?? getTranslated('status_updated_successfully', context),
          context,
          isError: false,
        );
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _statusUpdatingProductIds.remove(productId);
    notifyListeners();
    return isSuccess;
  }

  Future<void> loadNextPage() async {
    if (hasNextPage) {
      await getProductList(offset: _offset + 1);
    }
  }
}
