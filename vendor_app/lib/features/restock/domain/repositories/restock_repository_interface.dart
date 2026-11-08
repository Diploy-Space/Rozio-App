
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class RestockRepositoryInterface<T> extends RepositoryInterface{

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

  Future<ApiResponse> updateRestockProductQuantity(int restockRequestId, int currentStock, List <Variation> variation);

  Future<ApiResponse> updateProductQuantity(int? productId,int currentStock, List <Variation> variation);

}