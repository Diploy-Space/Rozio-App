import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/models/campaign_eligible_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/models/campaign_list_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/models/campaign_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/services/campaign_service_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/enums/campaign_status.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class CampaignController with ChangeNotifier {
  final CampaignServiceInterface campaignServiceInterface;
  CampaignController({required this.campaignServiceInterface});

  static const List<CampaignStatus?> tabFilters = [
    null,
    CampaignStatus.pending,
    CampaignStatus.approved,
    CampaignStatus.denied,
  ];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CampaignListModel? _campaignListModel;
  CampaignListModel? get campaignListModel => _campaignListModel;

  List<CampaignModel> get campaignList => _campaignListModel?.campaigns ?? [];

  CampaignModel? _campaignDetails;
  CampaignModel? get campaignDetails => _campaignDetails;

  bool _isDetailsLoading = false;
  bool get isDetailsLoading => _isDetailsLoading;

  CampaignEligibleProductListModel? _eligibleProductListModel;
  CampaignEligibleProductListModel? get eligibleProductListModel => _eligibleProductListModel;

  List<CampaignEligibleProductModel> get eligibleProducts => _eligibleProductListModel?.products ?? [];

  bool _isEligibleProductsLoading = false;
  bool get isEligibleProductsLoading => _isEligibleProductsLoading;

  String _eligibleSearchText = '';
  bool get isEligibleSearchActive => _eligibleSearchText.isNotEmpty;

  bool _isJoining = false;
  bool get isJoining => _isJoining;

  bool _isLeaving = false;
  bool get isLeaving => _isLeaving;

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  String _searchText = '';
  String get searchText => _searchText;
  bool get isSearchActive => _searchText.isNotEmpty;

  CampaignStatus? get selectedStatus => tabFilters[_selectedTabIndex];

  Future<void> getCampaignList(int offset, {bool reload = false, bool isUpdate = true}) async {
    if (reload || offset == 1) {
      _campaignListModel = null;
      _isLoading = true;
      if (isUpdate) {
        notifyListeners();
      }
    }

    final ApiResponse apiResponse = await campaignServiceInterface.getCampaignList(
      offset,
      searchText: _searchText,
      status: selectedStatus?.apiValue,
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data is Map) {
        final CampaignListModel newData = CampaignListModel.fromJson(Map<String, dynamic>.from(apiResponse.response!.data));

        if (offset == 1 || _campaignListModel == null) {
          _campaignListModel = newData;
        } else {
          _campaignListModel?.campaigns?.addAll(newData.campaigns ?? []);
          _campaignListModel?.offset = newData.offset;
          _campaignListModel?.totalSize = newData.totalSize;
        }
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getCampaignDetails(int id, {bool isUpdate = true}) async {
    _campaignDetails = null;
    _isDetailsLoading = true;
    if (isUpdate) {
      notifyListeners();
    }

    final ApiResponse apiResponse = await campaignServiceInterface.getCampaignDetails(id);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic data = apiResponse.response!.data;
      final dynamic campaign = data is Map && data['data'] is Map ? data['data'] : data;
      if (campaign is Map) {
        _campaignDetails = CampaignModel.fromJson(Map<String, dynamic>.from(campaign));
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isDetailsLoading = false;
    notifyListeners();
  }

  Future<void> getEligibleProducts(int campaignId, int offset, {bool reload = false, bool isUpdate = true}) async {
    if (reload || offset == 1) {
      _eligibleProductListModel = null;
      _isEligibleProductsLoading = true;
      if (isUpdate) {
        notifyListeners();
      }
    }

    final ApiResponse apiResponse = await campaignServiceInterface.getEligibleProducts(
      campaignId,
      offset,
      searchText: _eligibleSearchText,
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data is Map) {
        final CampaignEligibleProductListModel newData =
            CampaignEligibleProductListModel.fromJson(Map<String, dynamic>.from(apiResponse.response!.data));
        if (offset == 1 || _eligibleProductListModel == null) {
          _eligibleProductListModel = newData;
        } else {
          _eligibleProductListModel?.products?.addAll(newData.products ?? []);
          _eligibleProductListModel?.offset = newData.offset;
          _eligibleProductListModel?.totalSize = newData.totalSize;
        }
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isEligibleProductsLoading = false;
    notifyListeners();
  }

  Future<void> searchEligibleProducts(int campaignId, String text) async {
    _eligibleSearchText = text.trim();
    await getEligibleProducts(campaignId, 1, reload: true);
  }

  Future<void> clearEligibleProductSearch(int campaignId) async {
    _eligibleSearchText = '';
    await getEligibleProducts(campaignId, 1, reload: true);
  }

  Future<bool> joinCampaign(int campaignId, {required List<int> productIds, required List<double> discounts}) async {
    _isJoining = true;
    notifyListeners();

    final ApiResponse apiResponse = await campaignServiceInterface.joinCampaign(
      campaignId,
      productIds: productIds,
      discounts: discounts,
    );

    bool isSuccess = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic data = apiResponse.response!.data;
      final dynamic campaign = data is Map && data['data'] is Map ? data['data'] : null;
      if (campaign is Map) {
        _campaignDetails = CampaignModel.fromJson(Map<String, dynamic>.from(campaign));
      }
      isSuccess = true;
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isJoining = false;
    notifyListeners();

    if (isSuccess) {
      await getCampaignList(1, reload: true);
    }
    return isSuccess;
  }

  Future<bool> leaveCampaign(int campaignId) async {
    _isLeaving = true;
    notifyListeners();

    final ApiResponse apiResponse = await campaignServiceInterface.leaveCampaign(campaignId);

    bool isSuccess = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      isSuccess = true;
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLeaving = false;
    notifyListeners();

    if (isSuccess) {
      await getCampaignDetails(campaignId);
      await getCampaignList(1, reload: true);
    }
    return isSuccess;
  }

  Future<void> onChangeTab(int index) async {
    if (_selectedTabIndex == index) return;
    _selectedTabIndex = index;
    _searchText = '';
    await getCampaignList(1, reload: true);
  }

  Future<void> searchCampaign(String text) async {
    _searchText = text.trim();
    await getCampaignList(1, reload: true);
  }

  Future<void> clearSearch() async {
    _searchText = '';
    await getCampaignList(1, reload: true);
  }

  void resetForNewVisit() {
    _selectedTabIndex = 0;
    _searchText = '';
  }
}
