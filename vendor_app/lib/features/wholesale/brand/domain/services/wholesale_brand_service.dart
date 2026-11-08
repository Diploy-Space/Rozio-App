import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/brand/domain/repositories/wholesale_brand_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/brand/domain/services/wholesale_brand_service_interface.dart';

class WholesaleBrandService implements WholesaleBrandServiceInterface {
  final WholesaleBrandRepositoryInterface wholesaleBrandRepoInterface;
  WholesaleBrandService({required this.wholesaleBrandRepoInterface});

  @override
  Future<ApiResponse> getBrandList({int? limit, int? offset, String? search, String? sortBy}) {
    return wholesaleBrandRepoInterface.getBrandList(limit: limit, offset: offset, search: search, sortBy: sortBy);
  }
}
