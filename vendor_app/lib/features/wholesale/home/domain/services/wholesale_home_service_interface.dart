import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class WholesaleHomeServiceInterface {
  Future<ApiResponse> getOrderStatusCounts(String? dateType);
  Future<ApiResponse> getTopSellingProducts({required int offset, int limit});
  Future<ApiResponse> getMostPopularProducts({required int offset, int limit});
  Future<ApiResponse> getEarningStatistics(String? type);
}
