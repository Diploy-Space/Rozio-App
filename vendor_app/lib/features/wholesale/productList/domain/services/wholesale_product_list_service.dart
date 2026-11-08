import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/domain/repositories/wholesale_product_list_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/domain/services/wholesale_product_list_service_interface.dart';

class WholesaleProductListService implements WholesaleProductListServiceInterface {
  final WholesaleProductListRepositoryInterface wholesaleProductListRepoInterface;
  WholesaleProductListService({required this.wholesaleProductListRepoInterface});

  @override
  Future<ApiResponse> getProductList({
    required int offset,
    int limit = 20,
    String? state,
    String? search,
    String? sortBy,
    List<int>? productStatus,
    List<int>? brandIds,
    List<int>? categoryIds,
    List<int>? subCategoryIds,
    List<int>? subSubCategoryIds,
  }) {
    return wholesaleProductListRepoInterface.getProductList(
      offset: offset,
      limit: limit,
      state: state,
      search: search,
      sortBy: sortBy,
      productStatus: productStatus,
      brandIds: brandIds,
      categoryIds: categoryIds,
      subCategoryIds: subCategoryIds,
      subSubCategoryIds: subSubCategoryIds,
    );
  }

  @override
  Future<ApiResponse> deleteProduct(int productId) {
    return wholesaleProductListRepoInterface.delete(productId);
  }

  @override
  Future<ApiResponse> updateProductStatus(int productId, bool status) {
    return wholesaleProductListRepoInterface.updateStatus(productId, status);
  }
}
