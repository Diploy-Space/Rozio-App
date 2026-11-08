import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class WholesaleVatTaxServiceInterface {
  Future<ApiResponse> getSetup();

  Future<ApiResponse> getTaxList();
}
