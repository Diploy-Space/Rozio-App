import 'package:sixvalley_vendor_app/features/refund/domain/repositories/refund_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/services/refund_service_interface.dart';

class RefundService implements RefundServiceInterface{
  final RefundRepositoryInterface refundRepoInterface;
  RefundService({required this.refundRepoInterface});

  @override
  Future getRefundList(String? dateType, String? startDate, String? endDate, String? refundStatus, int offset) {
   return refundRepoInterface.getRefundList(dateType, startDate, endDate, refundStatus, offset);
  }

  @override
  Future getRefundReqDetails(int? refundId) {
    return refundRepoInterface.getRefundReqDetails(refundId);
  }

  @override
  Future getRefundStatusList(String type) {
    return refundRepoInterface.getRefundStatusList(type);
  }

  @override
  Future refundStatus(int? refundId, String status, String note) {
    return refundRepoInterface.refundStatus(refundId, status, note);
  }

  @override
  Future getSingleRefundModel(int? refundId) {
    return refundRepoInterface.getSingleRefundModel(refundId);
  }

  @override
  Future getRefundedProductFromOrderDetails(int orderId) {
    return refundRepoInterface.getRefundedProductFromOrderDetails(orderId);
  }
}
