import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/domain/repositories/wholesale_product_review_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productReview/domain/services/wholesale_product_review_service_interface.dart';

class WholesaleProductReviewService implements WholesaleProductReviewServiceInterface{
  final WholesaleProductReviewRepositoryInterface wholesaleProductReviewRepoInterface;
  WholesaleProductReviewService({required this.wholesaleProductReviewRepoInterface});

  @override
  Future<ApiResponse> getReviewList({required int offset, int limit = 10, String? search, int? productId, int? status, String? from, String? to}) {
    return wholesaleProductReviewRepoInterface.getReviewList(offset: offset, limit: limit, search: search, productId: productId, status: status, from: from, to: to);
  }

  @override
  Future<ApiResponse> sendReply(int reviewId, String replyText) {
    return wholesaleProductReviewRepoInterface.sendReply(reviewId, replyText);
  }

  @override
  Future<ApiResponse> updateStatus(int reviewId, bool status) {
    return wholesaleProductReviewRepoInterface.updateStatus(reviewId, status);
  }
}
