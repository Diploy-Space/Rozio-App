import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/models/order_list_filter_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/domain/repositories/wholesale_order_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleOrderRepository implements WholesaleOrderRepositoryInterface{
  final DioClient? dioClient;
  WholesaleOrderRepository({required this.dioClient});

  @override
  Future<ApiResponse> getOrderList(int offset, String status, OrderListFilterModel? filter, {String? searchValue}) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'limit': 10,
        'offset': offset,
        ...?filter?.toQueryParams(),
        if (searchValue != null && searchValue.isNotEmpty) 'search_value': searchValue,
      };

      if (status != 'all') {
        queryParameters['order_current_status'] = jsonEncode([status]);
      } else if (filter != null && filter.orderStatus.isNotEmpty) {
        queryParameters['order_current_status'] = jsonEncode(filter.orderStatus);
      }

      final response = await dioClient!.get(AppConstants.wholesaleOrders, queryParameters: queryParameters);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getOrderDetails(int orderId) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleOrders}/$orderId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getOrderInvoice(int orderId) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.wholesaleOrders}/$orderId/invoice',
        options: Options(responseType: ResponseType.bytes),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateOrderStatus(int orderId, String orderStatus) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleOrders}/$orderId/status', data: {'order_status': orderStatus});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> markPaid(int orderId) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleOrders}/$orderId/payment-status', data: {'payment_status': 'paid'});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> assignDeliveryMan(int orderId, int deliveryManId) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleOrders}/$orderId/delivery-man', data: {'delivery_man_id': deliveryManId});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateDeliverySchedule(int orderId, {double? deliverymanCharge, String? expectedDeliveryDate}) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleOrders}/$orderId/delivery-schedule', data: {
        if (deliverymanCharge != null) 'deliveryman_charge': deliverymanCharge,
        if (expectedDeliveryDate != null) 'expected_delivery_date': expectedDeliveryDate,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateAddress(int orderId, {required String addressType, String? contactPersonName, String? phone, String? city,
    String? zip, String? email, String? address, String? latitude, String? longitude}) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleOrders}/$orderId/address', data: {
        'address_type': addressType,
        'contact_person_name': contactPersonName,
        'phone': phone,
        'city': city,
        'zip': zip,
        'email': email,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    throw UnimplementedError();
  }
}
