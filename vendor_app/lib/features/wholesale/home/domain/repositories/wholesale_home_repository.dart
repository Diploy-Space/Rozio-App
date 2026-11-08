import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/domain/repositories/wholesale_home_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleHomeRepository implements WholesaleHomeRepositoryInterface{
  final DioClient? dioClient;
  WholesaleHomeRepository({required this.dioClient});

  @override
  Future<ApiResponse> getOrderStatusCounts(String? dateType) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleOrderStatusCounts, queryParameters: {if (dateType != null) 'date_type': dateType});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getTopSellingProducts({required int offset, int limit = 10}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleTopSellingProducts, queryParameters: {'limit': limit, 'offset': offset});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getMostPopularProducts({required int offset, int limit = 10}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleMostPopularProducts, queryParameters: {'limit': limit, 'offset': offset});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getEarningStatistics(String? type) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleEarningStatistics, queryParameters: {if (type != null) 'type': type});
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
  Future get(String id) {
    // TODO: implement get
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
}
