import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class WholesaleCouponRepositoryInterface implements RepositoryInterface {
  Future<ApiResponse> getCouponSetup();
  Future<ApiResponse> getCouponCustomerList(String search);
  Future<ApiResponse> updateCouponStatus(int? id, bool status);
}
