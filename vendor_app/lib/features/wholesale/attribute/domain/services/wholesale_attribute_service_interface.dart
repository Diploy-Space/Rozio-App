import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class WholesaleAttributeServiceInterface {
  Future<ApiResponse> getAttributeList({int? limit, int? offset, String? search, String? sortBy});
}
