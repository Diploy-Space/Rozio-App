abstract class ReviewServiceInterface {
  Future<dynamic> productReviewList(int offset);
  Future<dynamic> filterProductReviewList(int? productId, String? customerId, int status, String? from, String? to, int offset);
  Future<dynamic> searchProductReviewList(String search, int offset);
  Future<dynamic> reviewStatusOnOff(int? reviewId, int status);
  Future<dynamic> getProductWiseReviewList(int? productId,int offset);
  Future<dynamic> sendReviewReply(int? reviewId,String replyText);
}