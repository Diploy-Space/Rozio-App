import 'package:dio/dio.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/order_edit/domain/repositories/order_edit_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class OrderEditRepository implements OrderEditRepositoryInterface {
  final DioClient? dioClient;
  OrderEditRepository({required this.dioClient});


  @override
  Future<ApiResponse> getSellerProductList({required String sellerId, required String orderId, required int offset, required String languageCode, required String search }) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.editOrderAllProducts}/$orderId/edit/products',
        queryParameters: {'limit': 20, 'offset': offset, 'search': search, 'request_status': 1},
        options: Options(headers: {AppConstants.langKey: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> editOrderSubmit(Map<String, dynamic> data) async {
    try {
      final response = await dioClient!.put('${AppConstants.editOrderSubmit}/${data['order_id']}/edit', data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> editOrderValidation(Map<String, dynamic> data) async {
    try {
      final response = await dioClient!.post('${AppConstants.editOrderValidation}/${data['order_id']}/edit/validate', data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }


  @override
  Future<ApiResponse> switchToCod(int orderId) async {
    try {
      final response = await dioClient!.put('${AppConstants.switchToCod}/$orderId/edit/cash-on-delivery');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



}
