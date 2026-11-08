import 'package:sixvalley_vendor_app/features/auction/domain/repository/auction_product_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/auction/domain/services/auction_product_service_interface.dart';

class AuctionProductService implements AuctionProductServiceInterface {
  final AuctionProductRepositoryInterface auctionProductRepoInterface;
  AuctionProductService({required this.auctionProductRepoInterface});

  @override
  Future getAuctionRequestListV6({
    required int offset,
    required String approvalStatus,
    int limit = 10,
  }) async {
    return await auctionProductRepoInterface.getAuctionRequestListV6(
      offset: offset,
      approvalStatus: approvalStatus,
      limit: limit,
    );
  }

  @override
  Future getAuctionList({
    required int offset,
    String auctionStatus = '',
    String search = '',
    int limit = 10,
    Map<String, dynamic> extraParams = const {},
  }) async {
    return await auctionProductRepoInterface.getAuctionList(
      offset: offset,
      auctionStatus: auctionStatus,
      search: search,
      limit: limit,
      extraParams: extraParams,
    );
  }

  @override
  Future deleteAuctionProduct(int id) async {
    return await auctionProductRepoInterface.deleteAuctionProduct(id);
  }

  @override
  Future getAuctionProductDetailsV6(int id) async {
    return await auctionProductRepoInterface.getAuctionProductDetailsV6(id);
  }

  @override
  Future toggleAuctionStatus(int id, {required String status}) async {
    return await auctionProductRepoInterface.toggleAuctionStatus(id, status: status);
  }

  @override
  Future getBidList(int auctionProductId, {int limit = 10, int offset = 1}) async {
    return await auctionProductRepoInterface.getBidList(auctionProductId, limit: limit, offset: offset);
  }

  @override
  Future uploadTrackingUrl(int auctionProductId, String trackingUrl) async {
    return await auctionProductRepoInterface.uploadTrackingUrl(auctionProductId, trackingUrl);
  }

  @override
  Future updatePaymentStatus(
    int id, {
    required String paymentStatus,
  }) async {
    return await auctionProductRepoInterface.updatePaymentStatus(
      id,
      paymentStatus: paymentStatus,
    );
  }

  @override
  Future updateDeliveryStatus(int id, {required String deliveryStatus}) async {
    return await auctionProductRepoInterface.updateDeliveryStatus(id, deliveryStatus: deliveryStatus);
  }

  @override
  Future updateAuctionAddress({
    required int auctionProductId,
    required String addressType,
    String? contactPersonName,
    String? phone,
    String? city,
    String? zip,
    String? email,
    String? address,
    String? country,
  }) async {
    return await auctionProductRepoInterface.updateAuctionAddress(
      auctionProductId: auctionProductId,
      addressType: addressType,
      contactPersonName: contactPersonName,
      phone: phone,
      city: city,
      zip: zip,
      email: email,
      address: address,
      country: country,
    );
  }

  @override
  Future submitWithdrawRequest(Map<String, dynamic> data) async {
    return await auctionProductRepoInterface.submitWithdrawRequest(data);
  }

  @override
  Future updateWithdrawRequest(int withdrawId, Map<String, dynamic> data) async {
    return await auctionProductRepoInterface.updateWithdrawRequest(withdrawId, data);
  }

  @override
  Future payCommissionV6(int id, Map<String, dynamic> data) async {
    return await auctionProductRepoInterface.payCommissionV6(id, data);
  }

  @override
  Future getAuctionInvoiceV6(int auctionId) async {
    return await auctionProductRepoInterface.getAuctionInvoiceV6(auctionId);
  }

  @override
  Future getSalesReport({
    required int offset,
    String dateType = '',
    String? from,
    String? to,
    String search = '',
    int limit = 10,
  }) async {
    return await auctionProductRepoInterface.getSalesReport(
      offset: offset,
      dateType: dateType,
      from: from,
      to: to,
      search: search,
      limit: limit,
    );
  }

  @override
  Future getAuctionVatReport({
    required int limit,
    required int offset,
    String? startDate,
    String? endDate,
  }) async {
    return await auctionProductRepoInterface.getAuctionVatReport(
      limit: limit,
      offset: offset,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future cancelAuctionProduct(int id) async {
    return await auctionProductRepoInterface.cancelAuctionProduct(id);
  }
}
