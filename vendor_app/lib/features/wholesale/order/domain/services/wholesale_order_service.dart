import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/models/order_list_filter_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/domain/repositories/wholesale_order_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/domain/services/wholesale_order_service_interface.dart';

class WholesaleOrderService implements WholesaleOrderServiceInterface{
  final WholesaleOrderRepositoryInterface wholesaleOrderRepoInterface;
  WholesaleOrderService({required this.wholesaleOrderRepoInterface});

  @override
  Future<ApiResponse> getOrderList(int offset, String status, OrderListFilterModel? filter, {String? searchValue}) {
    return wholesaleOrderRepoInterface.getOrderList(offset, status, filter, searchValue: searchValue);
  }

  @override
  Future<ApiResponse> getOrderDetails(int orderId) {
    return wholesaleOrderRepoInterface.getOrderDetails(orderId);
  }

  @override
  Future<ApiResponse> getOrderInvoice(int orderId) {
    return wholesaleOrderRepoInterface.getOrderInvoice(orderId);
  }

  @override
  Future<ApiResponse> updateOrderStatus(int orderId, String orderStatus) {
    return wholesaleOrderRepoInterface.updateOrderStatus(orderId, orderStatus);
  }

  @override
  Future<ApiResponse> markPaid(int orderId) {
    return wholesaleOrderRepoInterface.markPaid(orderId);
  }

  @override
  Future<ApiResponse> assignDeliveryMan(int orderId, int deliveryManId) {
    return wholesaleOrderRepoInterface.assignDeliveryMan(orderId, deliveryManId);
  }

  @override
  Future<ApiResponse> updateDeliverySchedule(int orderId, {double? deliverymanCharge, String? expectedDeliveryDate}) {
    return wholesaleOrderRepoInterface.updateDeliverySchedule(orderId, deliverymanCharge: deliverymanCharge, expectedDeliveryDate: expectedDeliveryDate);
  }

  @override
  Future<ApiResponse> updateAddress(int orderId, {required String addressType, String? contactPersonName, String? phone, String? city,
    String? zip, String? email, String? address, String? latitude, String? longitude}) {
    return wholesaleOrderRepoInterface.updateAddress(orderId, addressType: addressType, contactPersonName: contactPersonName, phone: phone,
      city: city, zip: zip, email: email, address: address, latitude: latitude, longitude: longitude);
  }
}
