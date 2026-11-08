import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/domain/models/wholesale_limited_stock_product_model.dart';

abstract class WholesaleLimitedStockServiceInterface {
  Future<ApiResponse> getStockOutProductList({int offset = 1});
  Future<ApiResponse> getProductStock(int productId);
  Future<ApiResponse> updateProductQuantity(int productId, int currentStock, List<WholesaleLimitedStockVariation> variation);
}
