import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/models/order_list_filter_model.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class WholesaleOrderRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> getOrderList(int offset, String status, OrderListFilterModel? filter, {String? searchValue});
  Future<ApiResponse> getOrderDetails(int orderId);
  Future<ApiResponse> getOrderInvoice(int orderId);
  Future<ApiResponse> updateOrderStatus(int orderId, String orderStatus);
  Future<ApiResponse> markPaid(int orderId);
  Future<ApiResponse> assignDeliveryMan(int orderId, int deliveryManId);
  Future<ApiResponse> updateDeliverySchedule(int orderId, {double? deliverymanCharge, String? expectedDeliveryDate});
  Future<ApiResponse> updateAddress(int orderId, {required String addressType, String? contactPersonName, String? phone, String? city,
    String? zip, String? email, String? address, String? latitude, String? longitude});
}
