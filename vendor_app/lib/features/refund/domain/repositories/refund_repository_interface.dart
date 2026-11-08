
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class RefundRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> getRefundReqDetails(int? refundId);
  Future<ApiResponse> refundStatus(int? refundId , String status, String note);
  Future<ApiResponse> getRefundStatusList(String type);
  Future<ApiResponse> getSingleRefundModel(int? refundId);
  Future<ApiResponse> getRefundList(String? dateType, String? startDate, String? endDate, String? refundStatus, int offset);
  Future<ApiResponse> getRefundedProductFromOrderDetails(int orderId);
}