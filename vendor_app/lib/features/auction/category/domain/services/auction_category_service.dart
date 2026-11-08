import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/auction/category/domain/repositories/auction_category_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/auction/category/domain/services/auction_category_service_interface.dart';

class AuctionCategoryService implements AuctionCategoryServiceInterface {
  final AuctionCategoryRepositoryInterface auctionCategoryRepoInterface;
  AuctionCategoryService({required this.auctionCategoryRepoInterface});

  @override
  Future<ApiResponse> getCategoryList({int? limit, int? offset, String? search, String? sortBy}) {
    return auctionCategoryRepoInterface.getCategoryList(limit: limit, offset: offset, search: search, sortBy: sortBy);
  }
}
