import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/domain/repositories/wholesale_product_details_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleProductDetailsRepository implements WholesaleProductDetailsRepositoryInterface {
  final DioClient? dioClient;
  WholesaleProductDetailsRepository({required this.dioClient});

  @override
  Future<ApiResponse> getProductDetails(int id) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleProductDetails}$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateStatus(int id, bool status) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleProductStatus}$id/status', data: {'status': status});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateFaq(int faqId, {required List<String> languages, required List<String> questions, required List<String> answers, required int priority}) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleProductFaqs}$faqId', data: {
        'lang': languages,
        'question': questions,
        'answer': answers,
        'priority': priority,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateFaqStatus(int faqId, bool status) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleProductFaqs}$faqId/status', data: {'id': faqId, 'status': status});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> deleteFaq(int faqId) async {
    try {
      final response = await dioClient!.delete('${AppConstants.wholesaleProductFaqs}$faqId');
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
