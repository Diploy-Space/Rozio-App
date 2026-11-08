import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class WholesaleProductReviewRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> getReviewList({required int offset, int limit, String? search, int? productId, int? status, String? from, String? to});
  Future<ApiResponse> sendReply(int reviewId, String replyText);
  Future<ApiResponse> updateStatus(int reviewId, bool status);
}
