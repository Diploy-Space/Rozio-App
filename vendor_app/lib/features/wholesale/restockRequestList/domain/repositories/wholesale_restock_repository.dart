import 'dart:convert';

import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/domain/models/wholesale_restock_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/domain/repositories/wholesale_restock_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleRestockRepository implements WholesaleRestockRepositoryInterface {
  final DioClient? dioClient;
  WholesaleRestockRepository({required this.dioClient});

  @override
  Future<ApiResponse> getRestockProductList({
    required int offset,
    int limit = 10,
    int? categoryId,
    String? search,
    List<int>? brandIds,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'limit': limit,
        'offset': offset,
        if (categoryId != null) 'category_id': categoryId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (brandIds != null && brandIds.isNotEmpty) 'brand_ids': jsonEncode(brandIds),
        if (startDate != null && startDate.isNotEmpty) 'restock_start_date': startDate,
        if (endDate != null && endDate.isNotEmpty) 'restock_end_date': endDate,
      };

      final response = await dioClient!.get(AppConstants.wholesaleRestockRequests, queryParameters: queryParams);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getRestockBrandList() async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleRestockRequestBrands);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> deleteRestockItem(int id) async {
    try {
      final response = await dioClient!.delete('${AppConstants.wholesaleRestockRequests}/$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateRestockProductQuantity(int restockRequestId, {
    required int currentStock,
    required List<WholesaleRestockVariation> variation,
    required String variationType,
    required int variationQty,
  }) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleRestockRequests}/$restockRequestId/stock', data: {
        'current_stock': currentStock,
        'variation_type': variationType,
        'variation_qty': variationQty,
        if (variation.isNotEmpty) 'variation': variation.map((v) => v.toJson()).toList(),
      });
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
  Future getList({int? offset = 1}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    throw UnimplementedError();
  }
}
