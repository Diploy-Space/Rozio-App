import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class WholesaleProductListRepositoryInterface implements RepositoryInterface {
  Future<ApiResponse> getProductList({
    required int offset,
    int limit,
    String? state,
    String? search,
    String? sortBy,
    List<int>? productStatus,
    List<int>? brandIds,
    List<int>? categoryIds,
    List<int>? subCategoryIds,
    List<int>? subSubCategoryIds,
  });

  @override
  Future<ApiResponse> delete(int id);

  Future<ApiResponse> updateStatus(int id, bool status);
}
