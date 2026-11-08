import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class WholesaleHomeRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> getOrderStatusCounts(String? dateType);
  Future<ApiResponse> getTopSellingProducts({required int offset, int limit});
  Future<ApiResponse> getMostPopularProducts({required int offset, int limit});
  Future<ApiResponse> getEarningStatistics(String? type);
}
