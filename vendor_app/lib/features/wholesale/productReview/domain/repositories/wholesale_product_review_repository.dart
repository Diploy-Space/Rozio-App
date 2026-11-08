import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/domain/repositories/wholesale_product_review_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleProductReviewRepository implements WholesaleProductReviewRepositoryInterface{
  final DioClient? dioClient;

  WholesaleProductReviewRepository({required this.dioClient});

  @override
  Future<ApiResponse> getReviewList({required int offset, int limit = 10, String? search, int? productId, int? status, String? from, String? to}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleReviews, queryParameters: {
        'limit': limit,
        'offset': offset,
        if (search != null && search.isNotEmpty) 'search': search,
        if (productId != null) 'product_id': productId,
        if (status != null) 'status': status,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> sendReply(int reviewId, String replyText) async {
    try {
      final response = await dioClient!.post('${AppConstants.wholesaleReviews}/$reviewId/reply', data: {
        'id': reviewId,
        'reply_text': replyText,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateStatus(int reviewId, bool status) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleReviews}/$reviewId/status', data: {
        'id': reviewId,
        'status': status,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    throw UnimplementedError();
  }
}
