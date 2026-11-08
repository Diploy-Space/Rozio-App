import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class AuctionCategoryRepositoryInterface implements RepositoryInterface {
  Future<ApiResponse> getCategoryList({int? limit, int? offset, String? search, String? sortBy});
}
