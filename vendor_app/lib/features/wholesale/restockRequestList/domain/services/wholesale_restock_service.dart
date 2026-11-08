import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/domain/models/wholesale_restock_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/domain/repositories/wholesale_restock_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/domain/services/wholesale_restock_service_interface.dart';

class WholesaleRestockService implements WholesaleRestockServiceInterface {
  final WholesaleRestockRepositoryInterface wholesaleRestockRepositoryInterface;
  WholesaleRestockService({required this.wholesaleRestockRepositoryInterface});

  @override
  Future<ApiResponse> getRestockProductList({
    required int offset,
    int limit = 10,
    int? categoryId,
    String? search,
    List<int>? brandIds,
    String? startDate,
    String? endDate,
  }) {
    return wholesaleRestockRepositoryInterface.getRestockProductList(
      offset: offset,
      limit: limit,
      categoryId: categoryId,
      search: search,
      brandIds: brandIds,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<ApiResponse> getRestockBrandList() {
    return wholesaleRestockRepositoryInterface.getRestockBrandList();
  }

  @override
  Future<ApiResponse> deleteRestockItem(int id) {
    return wholesaleRestockRepositoryInterface.deleteRestockItem(id);
  }

  @override
  Future<ApiResponse> updateRestockProductQuantity(int restockRequestId, {
    required int currentStock,
    required List<WholesaleRestockVariation> variation,
    required String variationType,
    required int variationQty,
  }) {
    return wholesaleRestockRepositoryInterface.updateRestockProductQuantity(
      restockRequestId,
      currentStock: currentStock,
      variation: variation,
      variationType: variationType,
      variationQty: variationQty,
    );
  }
}
