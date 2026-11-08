import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';

abstract class RestockServiceInterface{

  Future<dynamic> getRestockProductList({
    required int offset,
    int limit,
    int? categoryId,
    String? search,
    List<int>? brandIds,
    String? startDate,
    String? endDate,
  });

  Future<dynamic> getRestockBrandList();

  Future<dynamic> deleteRestockItem(int id);

  Future<dynamic> updateRestockProductQuantity(int restockRequestId, int currentStock, List <Variation> variation);

  Future<dynamic> updateProductQuantity(int? productId,int currentStock, List <Variation> variation);

}