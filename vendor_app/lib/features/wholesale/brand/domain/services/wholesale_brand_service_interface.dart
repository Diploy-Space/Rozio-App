import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class WholesaleBrandServiceInterface {
  Future<ApiResponse> getBrandList({int? limit, int? offset, String? search, String? sortBy});
}
