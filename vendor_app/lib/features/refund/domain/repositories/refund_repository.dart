import 'package:dio/dio.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/repositories/refund_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class RefundRepository implements RefundRepositoryInterface{
  final DioClient? dioClient;
  RefundRepository({required this.dioClient});


  @override
  Future<ApiResponse> getRefundReqDetails(int? refundId) async {
    try {
      final response = await dioClient!.get('${AppConstants.refundItemDetails}/$refundId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> refundStatus(int? refundId , String status, String note) async {
    try {
      Response response = await dioClient!.put(
        '${AppConstants.refundReqStatusUpdate}/$refundId/status',
        data: {'refund_status': status, 'note' : note},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getRefundStatusList(String type) async {
    try {
      List<String> refundTypeList = [];
      refundTypeList = [
          'Select Refund Status',
          AppConstants.approved,
          AppConstants.rejected,
        ];
      Response response = Response(requestOptions: RequestOptions(path: ''), data: refundTypeList, statusCode: 200);
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
  Future getList({int? offset = 1}) async{
    try {
      final response = await dioClient!.get(AppConstants.refundListUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> getSingleRefundModel(int? refundId) async{
    try {
      final response = await dioClient!.get('${AppConstants.getSingleRefundModel}/$refundId/order-item');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getRefundList(String? dateType, String? startDate, String? endDate, String? refundStatus, int offset) async {
    try {
      final response = await dioClient!.get(AppConstants.refundListUri, queryParameters: {
        'limit': 10,
        'offset': offset,
        if (dateType != null) 'date_type': dateType,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (refundStatus != null) 'status': refundStatus,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getRefundedProductFromOrderDetails(int orderId) async {
    try {
      final response = await dioClient!.get('${AppConstants.orderDetails}$orderId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
