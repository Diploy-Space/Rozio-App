import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class AuctionVatTaxServiceInterface {
  Future<ApiResponse> getSetup();

  Future<ApiResponse> getTaxList();
}
