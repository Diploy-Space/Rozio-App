abstract class RefundServiceInterface {
  Future<dynamic> getRefundList(String? dateType, String? startDate, String? endDate, String? refundStatus, int offset);
  Future<dynamic> getRefundReqDetails(int? refundId);
  Future<dynamic> refundStatus(int? refundId , String status, String note);
  Future<dynamic> getRefundStatusList(String type);
  Future<dynamic> getSingleRefundModel(int? refundId);
  Future<dynamic> getRefundedProductFromOrderDetails(int orderId);
}