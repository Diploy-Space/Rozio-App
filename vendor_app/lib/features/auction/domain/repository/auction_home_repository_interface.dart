import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class AuctionHomeRepositoryInterface {
  Future<ApiResponse> getAuctionStatistics(String? dateType);
  Future<ApiResponse> getBidStatistics();
  Future<ApiResponse> getEarningStatistics(String type);
  Future<ApiResponse> getTopPerformingAuctions({required int offset, int limit});
  Future<ApiResponse> getRecentlyEndedAuctions({required int offset, int limit});
}
