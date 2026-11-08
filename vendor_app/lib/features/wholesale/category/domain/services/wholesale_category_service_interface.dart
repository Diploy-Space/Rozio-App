import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class WholesaleCategoryServiceInterface {
  Future<ApiResponse> getCategoryList({int? limit, int? offset, String? search, String? sortBy});
  Future<ApiResponse> getSubCategoryList(int categoryId, {int? limit, int? offset, String? search, String? sortBy});
  Future<ApiResponse> getSubSubCategoryList(int subCategoryId, {int? limit, int? offset, String? search, String? sortBy});
}
