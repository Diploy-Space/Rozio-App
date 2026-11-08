import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class CampaignRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> getCampaignList(int offset, {String? searchText, String? status});

  Future<ApiResponse> getCampaignDetails(int id);

  Future<ApiResponse> getEligibleProducts(int campaignId, int offset, {String? searchText});

  Future<ApiResponse> joinCampaign(int campaignId, {required List<int> productIds, required List<double> discounts});

  Future<ApiResponse> leaveCampaign(int campaignId);
}
