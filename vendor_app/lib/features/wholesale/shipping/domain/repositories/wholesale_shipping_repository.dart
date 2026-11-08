import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/shipping/domain/models/shipping_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/shipping/domain/repositories/wholesale_shipping_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleShippingRepository implements WholesaleShippingRepositoryInterface {
  final DioClient? dioClient;
  WholesaleShippingRepository({required this.dioClient});

  @override
  Future<ApiResponse> getList({int? offset = 1}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleShippingMethods,
          queryParameters: {'limit': 25, 'offset': offset});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> get(String id) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleShippingMethods}/$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> add(value) async {
    final ShippingModel shipping = value;
    try {
      final response = await dioClient!.post(AppConstants.wholesaleShippingMethods,
          data: {'title': shipping.title, 'duration': shipping.duration, 'cost': shipping.cost});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> update(Map<String, dynamic> body, int id) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleShippingMethods}/$id', data: body);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateShipping(String? title, String? duration, double? cost, int? id) {
    return update({'title': title, 'duration': duration, 'cost': cost}, id!);
  }

  @override
  Future<ApiResponse> delete(int id) async {
    try {
      final response = await dioClient!.delete('${AppConstants.wholesaleShippingMethods}/$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> shippingOnOff(int? id, int status) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleShippingMethods}/$id/status',
          data: {'id': id, 'status': status});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getCategoryWiseShippingMethod() async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleShippingCategoryCosts);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> setCategoryWiseShippingCost(List<int?> ids, List<double> cost, List<int> multiPly) async {
    try {
      final response = await dioClient!.put(AppConstants.wholesaleShippingCategoryCosts,
          data: {'ids': ids, 'cost': cost, 'multiply_qty': multiPly});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getSelectedShippingMethodType() async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleShippingType);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> setShippingMethodType(String? type) async {
    try {
      final response = await dioClient!.put(AppConstants.wholesaleShippingType, data: {'shippingType': type});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
