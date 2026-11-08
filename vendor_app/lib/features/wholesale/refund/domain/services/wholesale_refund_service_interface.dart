import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class WholesaleRefundServiceInterface {
  Future<ApiResponse> getRefundList({required int offset, String? status, String? dateType, String? startDate, String? endDate});
  Future<ApiResponse> getRefundDetails(int refundId);
  Future<ApiResponse> getRefundOrderItem(int refundId);
  Future<ApiResponse> updateRefundStatus(int refundId, {required String refundStatus, required String paymentInfo, String? approvedNote, String? rejectedNote});
}
