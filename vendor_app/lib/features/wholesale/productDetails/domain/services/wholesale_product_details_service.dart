import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/domain/repositories/wholesale_product_details_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/domain/services/wholesale_product_details_service_interface.dart';

class WholesaleProductDetailsService implements WholesaleProductDetailsServiceInterface {
  final WholesaleProductDetailsRepositoryInterface wholesaleProductDetailsRepoInterface;
  WholesaleProductDetailsService({required this.wholesaleProductDetailsRepoInterface});

  @override
  Future<ApiResponse> getProductDetails(int id) {
    return wholesaleProductDetailsRepoInterface.getProductDetails(id);
  }

  @override
  Future<ApiResponse> updateStatus(int id, bool status) {
    return wholesaleProductDetailsRepoInterface.updateStatus(id, status);
  }

  @override
  Future<ApiResponse> updateFaq(int faqId, {required List<String> languages, required List<String> questions, required List<String> answers, required int priority}) {
    return wholesaleProductDetailsRepoInterface.updateFaq(faqId, languages: languages, questions: questions, answers: answers, priority: priority);
  }

  @override
  Future<ApiResponse> updateFaqStatus(int faqId, bool status) {
    return wholesaleProductDetailsRepoInterface.updateFaqStatus(faqId, status);
  }

  @override
  Future<ApiResponse> deleteFaq(int faqId) {
    return wholesaleProductDetailsRepoInterface.deleteFaq(faqId);
  }
}
