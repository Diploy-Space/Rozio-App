import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/auction/brand/domain/repositories/auction_brand_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/auction/brand/domain/services/auction_brand_service_interface.dart';

class AuctionBrandService implements AuctionBrandServiceInterface {
  final AuctionBrandRepositoryInterface auctionBrandRepoInterface;
  AuctionBrandService({required this.auctionBrandRepoInterface});

  @override
  Future<ApiResponse> getBrandList({int? limit, int? offset, String? search, String? sortBy}) {
    return auctionBrandRepoInterface.getBrandList(limit: limit, offset: offset, search: search, sortBy: sortBy);
  }
}
