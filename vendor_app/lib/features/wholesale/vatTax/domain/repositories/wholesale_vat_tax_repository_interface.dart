import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class WholesaleVatTaxRepositoryInterface implements RepositoryInterface {
  Future<ApiResponse> getSetup();

  Future<ApiResponse> getTaxList();
}
