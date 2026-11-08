import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class WholesaleProductListServiceInterface {
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

  Future<ApiResponse> deleteProduct(int productId);

  Future<ApiResponse> updateProductStatus(int productId, bool status);
}
