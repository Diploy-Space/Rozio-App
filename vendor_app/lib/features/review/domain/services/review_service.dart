import 'package:sixvalley_vendor_app/features/review/domain/repositories/product_review_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/review/domain/services/review_service_interface.dart';

class ReviewService implements ReviewServiceInterface{
  final ProductReviewRepositoryInterface productReviewRepoInterface;
  ReviewService({required this.productReviewRepoInterface});

  @override
  Future filterProductReviewList(int? productId, String? customerId, int status, String? from, String? to, int offset) {
    return productReviewRepoInterface.filterProductReviewList(productId, customerId, status, from, to, offset);
  }

  @override
  Future productReviewList(int offset) {
    return productReviewRepoInterface.productReviewList(offset);
  }

  @override
  Future reviewStatusOnOff(int? reviewId, int status) {
    return productReviewRepoInterface.reviewStatusOnOff(reviewId, status);
  }

  @override
  Future searchProductReviewList(String search, int offset) {
    return productReviewRepoInterface.searchProductReviewList(search, offset);
  }

  @override
  Future getProductWiseReviewList(int? productId, int offset) {
    return productReviewRepoInterface.getProductWiseReviewList(productId, offset);
  }


  @override
  Future sendReviewReply(int? reviewId,String replyText) {
    return productReviewRepoInterface.sendReviewReply(reviewId, replyText);
  }

}