import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/domain/repositories/wholesale_product_list_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleProductListRepository implements WholesaleProductListRepositoryInterface {
  final DioClient? dioClient;
  WholesaleProductListRepository({required this.dioClient});

  @override
  Future<ApiResponse> getProductList({
    required int offset,
    int limit = 20,
    String? state,
    String? search,
    String? sortBy,
    List<int>? productStatus,
    List<int>? brandIds,
    List<int>? categoryIds,
    List<int>? subCategoryIds,
    List<int>? subSubCategoryIds,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'limit': limit,
        'offset': offset,
        if (state != null && state.isNotEmpty) 'state': state,
        if (search != null && search.isNotEmpty) 'search': search,
        if (sortBy != null && sortBy.isNotEmpty) 'filter_sort_by': sortBy,
        if (productStatus != null && productStatus.isNotEmpty) 'product_status': jsonEncode(productStatus),
        if (brandIds != null && brandIds.isNotEmpty) 'filter_brand_ids': jsonEncode(brandIds),
        if (categoryIds != null && categoryIds.isNotEmpty) 'filter_category_ids': jsonEncode(categoryIds),
        if (subCategoryIds != null && subCategoryIds.isNotEmpty) 'filter_sub_category_ids': jsonEncode(subCategoryIds),
        if (subSubCategoryIds != null && subSubCategoryIds.isNotEmpty) 'filter_sub_sub_category_ids': jsonEncode(subSubCategoryIds),
      };

      if (kDebugMode) {
        debugPrint('---Wholesale product list query--> $queryParams');
      }

      final response = await dioClient!.get(AppConstants.wholesaleProducts, queryParameters: queryParams);
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
  Future<ApiResponse> delete(int id) async {
    try {
      final response = await dioClient!.delete('${AppConstants.wholesaleProducts}/$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateStatus(int id, bool status) async {
    try {
      final response = await dioClient!.put(
        '${AppConstants.wholesaleProducts}/$id/status',
        data: {'status': status},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
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
