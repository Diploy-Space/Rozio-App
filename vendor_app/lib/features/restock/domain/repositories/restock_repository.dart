
import 'dart:async';
import 'dart:convert';

import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/features/restock/domain/repositories/restock_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class RestockRepository implements RestockRepositoryInterface{
  final DioClient? dioClient;
  RestockRepository({required this.dioClient});


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

      final response = await dioClient!.get(AppConstants.restockRequests, queryParameters: queryParams);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getRestockBrandList() async {
    try {
      final response = await dioClient!.get(AppConstants.restockRequestBrands);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> deleteRestockItem(int id) async {
    try {
      final response = await dioClient!.delete('${AppConstants.restockRequests}/$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> updateRestockProductQuantity(int restockRequestId, int currentStock, List <Variation> variation) async {
    try {
      final response = await dioClient!.put('${AppConstants.restockRequests}/$restockRequestId/stock',
          data: {
            "current_stock": currentStock,
            if (variation.isNotEmpty) "variation" : jsonEncode(variation),
          }
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> updateProductQuantity(int? productId,int currentStock, List <Variation> variation) async {
    try {
      final response = await dioClient!.put('${AppConstants.updateProductQuantity}/$productId/quantity',
          data: {
            "current_stock": currentStock,
            "variation" : variation,
          }
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }


  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

}
