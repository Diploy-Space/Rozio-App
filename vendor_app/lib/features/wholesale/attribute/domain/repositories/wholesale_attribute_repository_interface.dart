import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class WholesaleAttributeRepositoryInterface implements RepositoryInterface {
  Future<ApiResponse> getAttributeList({int? limit, int? offset, String? search, String? sortBy});
}
