import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/category/domain/repositories/wholesale_category_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/category/domain/services/wholesale_category_service_interface.dart';

class WholesaleCategoryService implements WholesaleCategoryServiceInterface {
  final WholesaleCategoryRepositoryInterface wholesaleCategoryRepoInterface;
  WholesaleCategoryService({required this.wholesaleCategoryRepoInterface});

  @override
  Future<ApiResponse> getCategoryList({int? limit, int? offset, String? search, String? sortBy}) {
    return wholesaleCategoryRepoInterface.getCategoryList(limit: limit, offset: offset, search: search, sortBy: sortBy);
  }

  @override
  Future<ApiResponse> getSubCategoryList(int categoryId, {int? limit, int? offset, String? search, String? sortBy}) {
    return wholesaleCategoryRepoInterface.getSubCategoryList(categoryId, limit: limit, offset: offset, search: search, sortBy: sortBy);
  }

  @override
  Future<ApiResponse> getSubSubCategoryList(int subCategoryId, {int? limit, int? offset, String? search, String? sortBy}) {
    return wholesaleCategoryRepoInterface.getSubSubCategoryList(subCategoryId, limit: limit, offset: offset, search: search, sortBy: sortBy);
  }
}
