import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/attribute/domain/repositories/wholesale_attribute_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/attribute/domain/services/wholesale_attribute_service_interface.dart';

class WholesaleAttributeService implements WholesaleAttributeServiceInterface {
  final WholesaleAttributeRepositoryInterface wholesaleAttributeRepoInterface;
  WholesaleAttributeService({required this.wholesaleAttributeRepoInterface});

  @override
  Future<ApiResponse> getAttributeList({int? limit, int? offset, String? search, String? sortBy}) {
    return wholesaleAttributeRepoInterface.getAttributeList(limit: limit, offset: offset, search: search, sortBy: sortBy);
  }
}
