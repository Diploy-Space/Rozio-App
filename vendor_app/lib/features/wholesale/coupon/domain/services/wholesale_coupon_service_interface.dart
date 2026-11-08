import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class WholesaleCouponServiceInterface {
  Future<ApiResponse> getCouponList(int offset);
  Future<ApiResponse> getCouponSetup();
  Future<ApiResponse> getCouponCustomerList(String search);
  Future<ApiResponse> addCoupon(Map<String, dynamic> body);
  Future<ApiResponse> updateCoupon(Map<String, dynamic> body, int id);
  Future<ApiResponse> updateCouponStatus(int? id, bool status);
  Future<ApiResponse> deleteCoupon(int id);
}
