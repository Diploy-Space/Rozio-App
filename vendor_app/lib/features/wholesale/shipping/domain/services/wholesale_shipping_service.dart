import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/shipping/domain/models/shipping_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/shipping/domain/repositories/wholesale_shipping_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/shipping/domain/services/wholesale_shipping_service_interface.dart';

class WholesaleShippingService implements WholesaleShippingServiceInterface {
  final WholesaleShippingRepositoryInterface wholesaleShippingRepoInterface;
  WholesaleShippingService({required this.wholesaleShippingRepoInterface});

  @override
  Future<ApiResponse> getShippingMethod({int offset = 1}) async {
    return await wholesaleShippingRepoInterface.getList(offset: offset);
  }

  @override
  Future<ApiResponse> addShipping(ShippingModel shipping) async {
    return await wholesaleShippingRepoInterface.add(shipping);
  }

  @override
  Future<ApiResponse> updateShipping(String? title, String? duration, double? cost, int? id) {
    return wholesaleShippingRepoInterface.updateShipping(title, duration, cost, id);
  }

  @override
  Future<ApiResponse> deleteShipping(int id) async {
    return await wholesaleShippingRepoInterface.delete(id);
  }

  @override
  Future<ApiResponse> shippingOnOff(int? id, int status) {
    return wholesaleShippingRepoInterface.shippingOnOff(id, status);
  }

  @override
  Future<ApiResponse> getCategoryWiseShippingMethod() {
    return wholesaleShippingRepoInterface.getCategoryWiseShippingMethod();
  }

  @override
  Future<ApiResponse> setCategoryWiseShippingCost(List<int?> ids, List<double> cost, List<int> multiPly) {
    return wholesaleShippingRepoInterface.setCategoryWiseShippingCost(ids, cost, multiPly);
  }

  @override
  Future<ApiResponse> getSelectedShippingMethodType() {
    return wholesaleShippingRepoInterface.getSelectedShippingMethodType();
  }

  @override
  Future<ApiResponse> setShippingMethodType(String? type) {
    return wholesaleShippingRepoInterface.setShippingMethodType(type);
  }
}
