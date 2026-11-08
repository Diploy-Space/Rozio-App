import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/domain/repositories/wholesale_refund_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleRefundRepository implements WholesaleRefundRepositoryInterface{
  final DioClient? dioClient;
  WholesaleRefundRepository({required this.dioClient});

  @override
  Future<ApiResponse> getRefundList({required int offset, String? status, String? dateType, String? startDate, String? endDate}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleRefunds, queryParameters: {
        'limit': 10,
        'offset': offset,
        if (status != null) 'status': status,
        if (dateType != null) 'date_type': dateType,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getRefundDetails(int refundId) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleRefunds}/$refundId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getRefundOrderItem(int refundId) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleRefunds}/$refundId/order-item');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateRefundStatus(int refundId, {required String refundStatus, required String paymentInfo, String? approvedNote, String? rejectedNote}) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleRefunds}/$refundId/status', data: {
        'id': refundId,
        'refund_status': refundStatus,
        'payment_info': paymentInfo,
        if (refundStatus == 'rejected')
          'rejected_note': rejectedNote
        else if (approvedNote != null && approvedNote.isNotEmpty)
          'approved_note': approvedNote,
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
