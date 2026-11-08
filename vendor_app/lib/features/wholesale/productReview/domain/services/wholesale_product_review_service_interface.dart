import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class WholesaleProductReviewServiceInterface {
  Future<ApiResponse> getReviewList({required int offset, int limit, String? search, int? productId, int? status, String? from, String? to});
  Future<ApiResponse> sendReply(int reviewId, String replyText);
  Future<ApiResponse> updateStatus(int reviewId, bool status);
}
