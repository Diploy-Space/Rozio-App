import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class WholesaleProductDetailsServiceInterface {
  Future<ApiResponse> getProductDetails(int id);
  Future<ApiResponse> updateStatus(int id, bool status);
  Future<ApiResponse> updateFaq(int faqId, {required List<String> languages, required List<String> questions, required List<String> answers, required int priority});
  Future<ApiResponse> updateFaqStatus(int faqId, bool status);
  Future<ApiResponse> deleteFaq(int faqId);
}
