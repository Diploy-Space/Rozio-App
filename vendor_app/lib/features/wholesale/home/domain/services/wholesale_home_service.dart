import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/domain/repositories/wholesale_home_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/domain/services/wholesale_home_service_interface.dart';

class WholesaleHomeService implements WholesaleHomeServiceInterface{
  final WholesaleHomeRepositoryInterface wholesaleHomeRepoInterface;
  WholesaleHomeService({required this.wholesaleHomeRepoInterface});

  @override
  Future<ApiResponse> getOrderStatusCounts(String? dateType) {
    return wholesaleHomeRepoInterface.getOrderStatusCounts(dateType);
  }

  @override
  Future<ApiResponse> getTopSellingProducts({required int offset, int limit = 10}) {
    return wholesaleHomeRepoInterface.getTopSellingProducts(offset: offset, limit: limit);
  }

  @override
  Future<ApiResponse> getMostPopularProducts({required int offset, int limit = 10}) {
    return wholesaleHomeRepoInterface.getMostPopularProducts(offset: offset, limit: limit);
  }

  @override
  Future<ApiResponse> getEarningStatistics(String? type) {
    return wholesaleHomeRepoInterface.getEarningStatistics(type);
  }
}
