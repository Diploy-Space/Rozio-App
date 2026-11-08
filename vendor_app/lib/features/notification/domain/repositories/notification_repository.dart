
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/notification/domain/repositories/notification_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class NotificationRepository implements NotificationRepositoryInterface{
  final DioClient? dioClient;
  NotificationRepository({required this.dioClient});

  @override
  Future<ApiResponse> seenNotification(int id) async {
    try {
      final response = await dioClient!.put('${AppConstants.seenNotification}$id/seen');
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
  Future getList({int? offset = 1}) async{
    try {
      final response = await dioClient!.get('${AppConstants.getNotificationList}?limit=20&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> getAuctionNotificationList({int limit = 10, int offset = 1}) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.auctionNotificationList}?limit=$limit&offset=$offset',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> markAuctionNotificationSeen({int? id}) async {
    try {
      final response = await dioClient!.put(
        AppConstants.auctionMarkNotificationSeen,
        queryParameters: id != null ? {'id': id} : null,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getWholesaleNotificationList({int limit = 10, int offset = 1}) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.wholesaleNotificationList}?limit=$limit&offset=$offset',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> markWholesaleNotificationSeen({required int id}) async {
    try {
      final response = await dioClient!.put(
        '${AppConstants.wholesaleMarkNotificationSeen}$id/seen',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}