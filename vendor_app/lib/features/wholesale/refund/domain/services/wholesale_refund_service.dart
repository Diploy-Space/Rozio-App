import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/domain/repositories/wholesale_refund_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/refund/domain/services/wholesale_refund_service_interface.dart';

class WholesaleRefundService implements WholesaleRefundServiceInterface{
  final WholesaleRefundRepositoryInterface wholesaleRefundRepoInterface;

  WholesaleRefundService({required this.wholesaleRefundRepoInterface});

  @override
  Future<ApiResponse> getRefundList({required int offset, String? status, String? dateType, String? startDate, String? endDate}) {
    return wholesaleRefundRepoInterface.getRefundList(offset: offset, status: status, dateType: dateType, startDate: startDate, endDate: endDate);
  }

  @override
  Future<ApiResponse> getRefundDetails(int refundId) {
    return wholesaleRefundRepoInterface.getRefundDetails(refundId);
  }

  @override
  Future<ApiResponse> getRefundOrderItem(int refundId) {
    return wholesaleRefundRepoInterface.getRefundOrderItem(refundId);
  }

  @override
  Future<ApiResponse> updateRefundStatus(int refundId, {required String refundStatus, required String paymentInfo, String? approvedNote, String? rejectedNote}) {
    return wholesaleRefundRepoInterface.updateRefundStatus(refundId, refundStatus: refundStatus, paymentInfo: paymentInfo, approvedNote: approvedNote, rejectedNote: rejectedNote);
  }
}
