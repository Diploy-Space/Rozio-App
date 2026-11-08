import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/repositories/campaign_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/services/campaign_service_interface.dart';

class CampaignService implements CampaignServiceInterface{
  final CampaignRepositoryInterface campaignRepoInterface;
  CampaignService({required this.campaignRepoInterface});

  @override
  Future<ApiResponse> getCampaignList(int offset, {String? searchText, String? status}) {
    return campaignRepoInterface.getCampaignList(offset, searchText: searchText, status: status);
  }

  @override
  Future<ApiResponse> getCampaignDetails(int id) {
    return campaignRepoInterface.getCampaignDetails(id);
  }

  @override
  Future<ApiResponse> getEligibleProducts(int campaignId, int offset, {String? searchText}) {
    return campaignRepoInterface.getEligibleProducts(campaignId, offset, searchText: searchText);
  }

  @override
  Future<ApiResponse> joinCampaign(int campaignId, {required List<int> productIds, required List<double> discounts}) {
    return campaignRepoInterface.joinCampaign(campaignId, productIds: productIds, discounts: discounts);
  }

  @override
  Future<ApiResponse> leaveCampaign(int campaignId) {
    return campaignRepoInterface.leaveCampaign(campaignId);
  }
}
