import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/domain/repositories/wholesale_coupon_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleCouponRepository implements WholesaleCouponRepositoryInterface {
  final DioClient? dioClient;
  WholesaleCouponRepository({required this.dioClient});

  @override
  Future<ApiResponse> getList({int? offset = 1}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleCoupons,
          queryParameters: {'limit': 10, 'offset': offset});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> get(String id) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleCoupons}/$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getCouponSetup() async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleCouponSetup);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getCouponCustomerList(String search) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleCouponCustomers,
          queryParameters: {'limit': 10, 'offset': 1, if (search.isNotEmpty) 'search': search});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> add(value) async {
    try {
      final response = await dioClient!.post(AppConstants.wholesaleCoupons, data: value);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> update(Map<String, dynamic> body, int id) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleCoupons}/$id', data: body);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateCouponStatus(int? id, bool status) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleCoupons}/$id/status',
          data: {'status': status});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> delete(int id) async {
    try {
      final response = await dioClient!.delete('${AppConstants.wholesaleCoupons}/$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
