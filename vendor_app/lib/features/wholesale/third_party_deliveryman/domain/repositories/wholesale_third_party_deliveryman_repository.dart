import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/third_party_deliveryman/domain/repositories/wholesale_third_party_deliveryman_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleThirdPartyDeliverymanRepository implements WholesaleThirdPartyDeliverymanRepositoryInterface {
  final DioClient? dioClient;
  WholesaleThirdPartyDeliverymanRepository({required this.dioClient});

  @override
  Future<ApiResponse> getCourierConfig() async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleCourierConfigUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> saveCourierConfig(Map<String, dynamic> body) async {
    try {
      final response = await dioClient!.put(AppConstants.wholesaleCourierConfigUri, data: body);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getEnabledProviders() async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleCourierProvidersUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> sendToCourier(Map<String, dynamic> body) async {
    try {
      final response = await dioClient!.post(AppConstants.wholesaleCourierDispatchUri, data: body);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> reviseDeliveryDetails(Map<String, dynamic> body) async {
    try {
      final response = await dioClient!.post(AppConstants.wholesaleCourierReviseUri, data: body);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> estimateDeliveryCharge(Map<String, dynamic> body) async {
    try {
      final response = await dioClient!.post(AppConstants.wholesaleCourierEstimateUri, data: body);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getTrackingHistory(String consignmentId) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleCourierTrackUri}${Uri.encodeComponent(consignmentId)}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getCourierLocationStores(String provider) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleCourierLocationStoresUri, queryParameters: {'provider': provider});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getCourierLocationCities(String provider) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleCourierLocationCitiesUri, queryParameters: {'provider': provider});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getCourierLocationZones(String provider, String cityId) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleCourierLocationZonesUri}$cityId', queryParameters: {'provider': provider});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getCourierLocationAreas(String provider, String zoneId) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleCourierLocationAreasUri}$zoneId', queryParameters: {'provider': provider});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) => throw UnimplementedError();

  @override
  Future delete(int id) => throw UnimplementedError();

  @override
  Future get(String id) => throw UnimplementedError();

  @override
  Future getList({int? offset = 1}) => throw UnimplementedError();

  @override
  Future update(Map<String, dynamic> body, int id) => throw UnimplementedError();
}
