import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/restockRequestList/domain/models/wholesale_restock_product_model.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class WholesaleRestockRepositoryInterface extends RepositoryInterface {
  Future<ApiResponse> getRestockProductList({
    required int offset,
    int limit,
    int? categoryId,
    String? search,
    List<int>? brandIds,
    String? startDate,
    String? endDate,
  });

  Future<ApiResponse> getRestockBrandList();

  Future<ApiResponse> deleteRestockItem(int id);

  Future<ApiResponse> updateRestockProductQuantity(int restockRequestId, {
    required int currentStock,
    required List<WholesaleRestockVariation> variation,
    required String variationType,
    required int variationQty,
  });
}
