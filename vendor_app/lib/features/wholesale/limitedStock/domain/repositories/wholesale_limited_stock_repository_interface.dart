import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/limitedStock/domain/models/wholesale_limited_stock_product_model.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class WholesaleLimitedStockRepositoryInterface implements RepositoryInterface {
  Future<ApiResponse> updateProductQuantity(int productId, int currentStock, List<WholesaleLimitedStockVariation> variation);
}
