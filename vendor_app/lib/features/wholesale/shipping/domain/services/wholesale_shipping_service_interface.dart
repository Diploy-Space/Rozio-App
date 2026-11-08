import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/shipping/domain/models/shipping_model.dart';

abstract class WholesaleShippingServiceInterface {
  Future<ApiResponse> getShippingMethod({int offset = 1});
  Future<ApiResponse> addShipping(ShippingModel shipping);
  Future<ApiResponse> updateShipping(String? title, String? duration, double? cost, int? id);
  Future<ApiResponse> deleteShipping(int id);
  Future<ApiResponse> shippingOnOff(int? id, int status);
  Future<ApiResponse> getCategoryWiseShippingMethod();
  Future<ApiResponse> setCategoryWiseShippingCost(List<int?> ids, List<double> cost, List<int> multiPly);
  Future<ApiResponse> getSelectedShippingMethodType();
  Future<ApiResponse> setShippingMethodType(String? type);
}
