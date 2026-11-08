import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class AuctionBrandServiceInterface {
  Future<ApiResponse> getBrandList({int? limit, int? offset, String? search, String? sortBy});
}
