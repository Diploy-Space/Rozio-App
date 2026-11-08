import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/category/domain/repositories/wholesale_category_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleCategoryRepository implements WholesaleCategoryRepositoryInterface {
  final DioClient? dioClient;
  WholesaleCategoryRepository({required this.dioClient});

  @override
  Future<ApiResponse> getCategoryList({int? limit, int? offset, String? search, String? sortBy}) {
    return _getList(AppConstants.wholesaleCategoryList, limit: limit, offset: offset, search: search, sortBy: sortBy);
  }

  @override
  Future<ApiResponse> getSubCategoryList(int categoryId, {int? limit, int? offset, String? search, String? sortBy}) {
    return _getList('${AppConstants.wholesaleSubCategoryList}$categoryId', limit: limit, offset: offset, search: search, sortBy: sortBy);
  }

  @override
  Future<ApiResponse> getSubSubCategoryList(int subCategoryId, {int? limit, int? offset, String? search, String? sortBy}) {
    return _getList('${AppConstants.wholesaleSubSubCategoryList}$subCategoryId', limit: limit, offset: offset, search: search, sortBy: sortBy);
  }

  Future<ApiResponse> _getList(String uri, {int? limit, int? offset, String? search, String? sortBy}) async {
    try {
      final response = await dioClient!.get(
        uri,
        queryParameters: {
          if (limit != null) 'limit': '$limit',
          if (offset != null) 'offset': offset,
          if (search != null && search.isNotEmpty) 'search': search,
          if (sortBy != null && sortBy.isNotEmpty) 'sort_by': sortBy,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    throw UnimplementedError();
  }
}
