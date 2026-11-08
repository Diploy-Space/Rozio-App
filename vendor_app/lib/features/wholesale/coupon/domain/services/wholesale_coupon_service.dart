import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/domain/repositories/wholesale_coupon_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/coupon/domain/services/wholesale_coupon_service_interface.dart';

class WholesaleCouponService implements WholesaleCouponServiceInterface {
  final WholesaleCouponRepositoryInterface wholesaleCouponRepoInterface;
  WholesaleCouponService({required this.wholesaleCouponRepoInterface});

  @override
  Future<ApiResponse> getCouponList(int offset) async => await wholesaleCouponRepoInterface.getList(offset: offset);

  @override
  Future<ApiResponse> getCouponSetup() => wholesaleCouponRepoInterface.getCouponSetup();

  @override
  Future<ApiResponse> getCouponCustomerList(String search) => wholesaleCouponRepoInterface.getCouponCustomerList(search);

  @override
  Future<ApiResponse> addCoupon(Map<String, dynamic> body) async => await wholesaleCouponRepoInterface.add(body);

  @override
  Future<ApiResponse> updateCoupon(Map<String, dynamic> body, int id) async => await wholesaleCouponRepoInterface.update(body, id);

  @override
  Future<ApiResponse> updateCouponStatus(int? id, bool status) => wholesaleCouponRepoInterface.updateCouponStatus(id, status);

  @override
  Future<ApiResponse> deleteCoupon(int id) async => await wholesaleCouponRepoInterface.delete(id);
}
