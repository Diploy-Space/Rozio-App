import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatTax/domain/repositories/wholesale_vat_tax_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatTax/domain/services/wholesale_vat_tax_service_interface.dart';

class WholesaleVatTaxService implements WholesaleVatTaxServiceInterface {
  final WholesaleVatTaxRepositoryInterface wholesaleVatTaxRepoInterface;
  WholesaleVatTaxService({required this.wholesaleVatTaxRepoInterface});

  @override
  Future<ApiResponse> getSetup() => wholesaleVatTaxRepoInterface.getSetup();

  @override
  Future<ApiResponse> getTaxList() => wholesaleVatTaxRepoInterface.getTaxList();
}
