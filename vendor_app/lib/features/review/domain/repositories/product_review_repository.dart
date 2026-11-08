import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/review/domain/repositories/product_review_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class ProductReviewRepository implements ProductReviewRepositoryInterface{
  final DioClient? dioClient;
  ProductReviewRepository({required this.dioClient});

  @override
  Future<ApiResponse> productReviewList(int offset) async {
    try {
      final response = await dioClient!.get(AppConstants.productReviewUri, queryParameters: {'limit': 10, 'offset': offset});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> filterProductReviewList(int? productId, String? customerId, int status, String? from, String? to, int offset) async {
    try {
      final response = await dioClient!.get(AppConstants.productReviewUri, queryParameters: {
        if (productId != null && productId != 0) 'product_id': productId,
        if (customerId != null && customerId != 'all' && customerId != '0') 'customer_id': customerId,
        if (status != 3) 'status': status,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
        'limit': 10,
        'offset': offset,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> searchProductReviewList(String search, int offset) async {
    try {
      final response = await dioClient!.get(AppConstants.productReviewUri, queryParameters: {'search': search, 'limit': 10, 'offset': offset});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> reviewStatusOnOff(int? reviewId, int status) async {
    try {
      final response = await dioClient!.put('${AppConstants.productReviewStatusOnOff}/$reviewId/status', data: {'status': status});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> getProductWiseReviewList(int? productId,int offset) async {
    try {
      final response = await dioClient!.get('${AppConstants.productWiseReviewList}/$productId/reviews', queryParameters: {'limit': 10, 'offset': offset});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> sendReviewReply(int? reviewId, String replyText) async{
    try {
      final response = await dioClient!.post('${AppConstants.reviewReply}/$reviewId/reply',
         data: {"reply_text" : replyText}
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