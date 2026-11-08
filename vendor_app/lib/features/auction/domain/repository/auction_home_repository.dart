import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/auction/domain/repository/auction_home_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class AuctionHomeRepository implements AuctionHomeRepositoryInterface {
  final DioClient? dioClient;
  AuctionHomeRepository({required this.dioClient});

  @override
  Future<ApiResponse> getAuctionStatistics(String? dateType) async {
    try {
      final response = await dioClient!.get(AppConstants.auctionDashboardStatistics, queryParameters: {if (dateType != null) 'date_type': dateType});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getBidStatistics() async {
    try {
      final response = await dioClient!.get(AppConstants.auctionBidStatistics);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getEarningStatistics(String type) async {
    try {
      final response = await dioClient!.get(AppConstants.auctionEarningStatistics, queryParameters: {'type': type});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getTopPerformingAuctions({required int offset, int limit = 10}) async {
    try {
      final response = await dioClient!.get(AppConstants.auctionTopPerformingProducts, queryParameters: {'limit': limit, 'offset': offset});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getRecentlyEndedAuctions({required int offset, int limit = 10}) async {
    try {
      final response = await dioClient!.get(AppConstants.auctionRecentlyEndedProducts, queryParameters: {'limit': limit, 'offset': offset});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
