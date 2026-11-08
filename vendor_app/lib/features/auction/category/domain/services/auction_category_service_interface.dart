import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class AuctionCategoryServiceInterface {
  Future<ApiResponse> getCategoryList({int? limit, int? offset, String? search, String? sortBy});
}
