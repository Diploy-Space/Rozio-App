import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/domain/models/wholesale_limited_stock_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/domain/repositories/wholesale_limited_stock_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleLimitedStockRepository implements WholesaleLimitedStockRepositoryInterface {
  final DioClient? dioClient;
  WholesaleLimitedStockRepository({required this.dioClient});

  @override
  Future<ApiResponse> getList({int? offset = 1}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleStockOutProducts,
          queryParameters: {'limit': 10, 'offset': offset});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> get(String id) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleProductDetails}$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateProductQuantity(int productId, int currentStock, List<WholesaleLimitedStockVariation> variation) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleProducts}/$productId/quantity', data: {
        'current_stock': currentStock,
        'variation': variation.map((v) => v.toJson()).toList(),
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
  Future update(Map<String, dynamic> body, int id) {
    throw UnimplementedError();
  }
}
