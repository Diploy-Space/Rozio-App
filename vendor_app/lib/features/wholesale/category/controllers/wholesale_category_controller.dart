import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/category/domain/models/wholesale_category_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/category/domain/services/wholesale_category_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class WholesaleCategoryController with ChangeNotifier {
  final WholesaleCategoryServiceInterface wholesaleCategoryServiceInterface;
  WholesaleCategoryController({required this.wholesaleCategoryServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<WholesaleCategoryModel>? _categoryList;
  List<WholesaleCategoryModel>? get categoryList => _categoryList;

  List<WholesaleCategoryModel>? _subCategoryList;
  List<WholesaleCategoryModel>? get subCategoryList => _subCategoryList;

  List<WholesaleCategoryModel>? _subSubCategoryList;
  List<WholesaleCategoryModel>? get subSubCategoryList => _subSubCategoryList;

  int? _selectedCategoryId;
  int? get selectedCategoryId => _selectedCategoryId;

  int? _selectedSubCategoryId;
  int? get selectedSubCategoryId => _selectedSubCategoryId;

  int? _selectedSubSubCategoryId;
  int? get selectedSubSubCategoryId => _selectedSubSubCategoryId;

  Future<void> getCategoryList({int limit = 200, int offset = 1, bool reload = false, bool isUpdate = true}) async {
    if (!reload && _categoryList != null && _categoryList!.isNotEmpty) {
      return;
    }

    _isLoading = true;
    if (isUpdate) {
      notifyListeners();
    }

    final ApiResponse apiResponse = await wholesaleCategoryServiceInterface.getCategoryList(limit: limit, offset: offset);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _categoryList = WholesaleCategoryListModel.fromJson(apiResponse.response!.data).categories;
    } else {
      _categoryList = [];
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> onSelectCategory(int? categoryId) async {
    _selectedCategoryId = categoryId;
    _selectedSubCategoryId = null;
    _selectedSubSubCategoryId = null;
    _subCategoryList = null;
    _subSubCategoryList = null;
    notifyListeners();

    if (categoryId == null) {
      return;
    }

    final ApiResponse apiResponse = await wholesaleCategoryServiceInterface.getSubCategoryList(categoryId, limit: 200, offset: 1);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _subCategoryList = WholesaleCategoryListModel.fromJson(apiResponse.response!.data).categories;
    } else {
      _subCategoryList = [];
      ApiChecker.checkApi(apiResponse);
    }

    notifyListeners();
  }

  Future<void> onSelectSubCategory(int? subCategoryId) async {
    _selectedSubCategoryId = subCategoryId;
    _selectedSubSubCategoryId = null;
    _subSubCategoryList = null;
    notifyListeners();

    if (subCategoryId == null) {
      return;
    }

    final ApiResponse apiResponse = await wholesaleCategoryServiceInterface.getSubSubCategoryList(subCategoryId, limit: 200, offset: 1);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _subSubCategoryList = WholesaleCategoryListModel.fromJson(apiResponse.response!.data).categories;
    } else {
      _subSubCategoryList = [];
      ApiChecker.checkApi(apiResponse);
    }

    notifyListeners();
  }

  void onSelectSubSubCategory(int? subSubCategoryId) {
    _selectedSubSubCategoryId = subSubCategoryId;
    notifyListeners();
  }

  final Map<int, List<WholesaleCategoryModel>> _subCategoriesByCategory = {};
  final Map<int, List<WholesaleCategoryModel>> _subSubCategoriesBySubCategory = {};

  List<WholesaleCategoryModel>? subCategoriesOf(int categoryId) => _subCategoriesByCategory[categoryId];
  List<WholesaleCategoryModel>? subSubCategoriesOf(int subCategoryId) => _subSubCategoriesBySubCategory[subCategoryId];

  Future<void> loadSubCategoriesOf(int categoryId) async {
    if (_subCategoriesByCategory.containsKey(categoryId)) {
      return;
    }

    final ApiResponse apiResponse = await wholesaleCategoryServiceInterface.getSubCategoryList(categoryId, limit: 200, offset: 1);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _subCategoriesByCategory[categoryId] = WholesaleCategoryListModel.fromJson(apiResponse.response!.data).categories;
    } else {
      _subCategoriesByCategory[categoryId] = [];
      ApiChecker.checkApi(apiResponse);
    }

    notifyListeners();
  }

  Future<void> loadSubSubCategoriesOf(int subCategoryId) async {
    if (_subSubCategoriesBySubCategory.containsKey(subCategoryId)) {
      return;
    }

    final ApiResponse apiResponse = await wholesaleCategoryServiceInterface.getSubSubCategoryList(subCategoryId, limit: 200, offset: 1);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _subSubCategoriesBySubCategory[subCategoryId] = WholesaleCategoryListModel.fromJson(apiResponse.response!.data).categories;
    } else {
      _subSubCategoriesBySubCategory[subCategoryId] = [];
      ApiChecker.checkApi(apiResponse);
    }

    notifyListeners();
  }

  void resetSelection({bool notify = true}) {
    _selectedCategoryId = null;
    _selectedSubCategoryId = null;
    _selectedSubSubCategoryId = null;
    _subCategoryList = null;
    _subSubCategoryList = null;
    if (notify) notifyListeners();
  }
}
