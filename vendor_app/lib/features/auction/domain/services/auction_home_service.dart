import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/auction/domain/repository/auction_home_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/auction/domain/services/auction_home_service_interface.dart';

class AuctionHomeService implements AuctionHomeServiceInterface {
  final AuctionHomeRepositoryInterface repositoryInterface;
  AuctionHomeService({required this.repositoryInterface});

  @override
  Future<ApiResponse> getAuctionStatistics(String? dateType) {
    return repositoryInterface.getAuctionStatistics(dateType);
  }

  @override
  Future<ApiResponse> getBidStatistics() {
    return repositoryInterface.getBidStatistics();
  }

  @override
  Future<ApiResponse> getEarningStatistics(String type) {
    return repositoryInterface.getEarningStatistics(type);
  }

  @override
  Future<ApiResponse> getTopPerformingAuctions({required int offset, int limit = 10}) {
    return repositoryInterface.getTopPerformingAuctions(offset: offset, limit: limit);
  }

  @override
  Future<ApiResponse> getRecentlyEndedAuctions({required int offset, int limit = 10}) {
    return repositoryInterface.getRecentlyEndedAuctions(offset: offset, limit: limit);
  }
}
