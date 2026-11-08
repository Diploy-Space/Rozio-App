import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/campaign/domain/repositories/campaign_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class CampaignRepository implements CampaignRepositoryInterface{
  final DioClient? dioClient;
  CampaignRepository({required this.dioClient});

  @override
  Future<ApiResponse> getCampaignList(int offset, {String? searchText, String? status}) async {
    try {
      final response = await dioClient!.get(AppConstants.campaignList, queryParameters: {
        'limit': 10,
        'offset': offset,
        if (searchText != null && searchText.isNotEmpty) 'search': searchText,
        if (status != null && status.isNotEmpty) 'status': status,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getCampaignDetails(int id) async {
    try {
      final response = await dioClient!.get('${AppConstants.campaignDetails}$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getEligibleProducts(int campaignId, int offset, {String? searchText}) async {
    try {
      final response = await dioClient!.get(
        AppConstants.campaignEligibleProducts.replaceFirst('{campaign}', '$campaignId'),
        queryParameters: {
          'limit': 25,
          'offset': offset,
          if (searchText != null && searchText.isNotEmpty) 'search': searchText,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> joinCampaign(int campaignId, {required List<int> productIds, required List<double> discounts}) async {
    try {
      final response = await dioClient!.post(
        AppConstants.campaignJoin.replaceFirst('{campaign}', '$campaignId'),
        data: {'product_id': productIds, 'discount': discounts},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> leaveCampaign(int campaignId) async {
    try {
      final response = await dioClient!.delete(
        AppConstants.campaignLeave.replaceFirst('{campaign}', '$campaignId'),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
