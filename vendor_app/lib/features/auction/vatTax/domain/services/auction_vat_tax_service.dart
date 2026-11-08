import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/auction/vatTax/domain/repositories/auction_vat_tax_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/auction/vatTax/domain/services/auction_vat_tax_service_interface.dart';

class AuctionVatTaxService implements AuctionVatTaxServiceInterface {
  final AuctionVatTaxRepositoryInterface auctionVatTaxRepoInterface;
  AuctionVatTaxService({required this.auctionVatTaxRepoInterface});

  @override
  Future<ApiResponse> getSetup() => auctionVatTaxRepoInterface.getSetup();

  @override
  Future<ApiResponse> getTaxList() => auctionVatTaxRepoInterface.getTaxList();
}
