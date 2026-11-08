import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/auction/category/domain/repositories/auction_category_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class AuctionCategoryRepository implements AuctionCategoryRepositoryInterface {
  final DioClient? dioClient;
  AuctionCategoryRepository({required this.dioClient});

  @override
  Future<ApiResponse> getCategoryList({int? limit, int? offset, String? search, String? sortBy}) async {
    try {
      final response = await dioClient!.get(
        AppConstants.auctionCategoryList,
        queryParameters: {
          if (limit != null) 'limit': '$limit',
          if (offset != null) 'offset': offset,
          if (search != null && search.isNotEmpty) 'search': search,
          if (sortBy != null && sortBy.isNotEmpty) 'sort_by': sortBy,
        },
      );
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
