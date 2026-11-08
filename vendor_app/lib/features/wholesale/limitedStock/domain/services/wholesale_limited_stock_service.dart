import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/domain/models/wholesale_limited_stock_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/domain/repositories/wholesale_limited_stock_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/domain/services/wholesale_limited_stock_service_interface.dart';

class WholesaleLimitedStockService implements WholesaleLimitedStockServiceInterface {
  final WholesaleLimitedStockRepositoryInterface wholesaleLimitedStockRepoInterface;
  WholesaleLimitedStockService({required this.wholesaleLimitedStockRepoInterface});

  @override
  Future<ApiResponse> getStockOutProductList({int offset = 1}) async {
    return await wholesaleLimitedStockRepoInterface.getList(offset: offset);
  }

  @override
  Future<ApiResponse> getProductStock(int productId) async {
    return await wholesaleLimitedStockRepoInterface.get('$productId');
  }

  @override
  Future<ApiResponse> updateProductQuantity(int productId, int currentStock, List<WholesaleLimitedStockVariation> variation) {
    return wholesaleLimitedStockRepoInterface.updateProductQuantity(productId, currentStock, variation);
  }
}
