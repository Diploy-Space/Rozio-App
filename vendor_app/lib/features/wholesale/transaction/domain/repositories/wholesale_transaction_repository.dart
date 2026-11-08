import 'package:dio/dio.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/transaction/domain/repositories/wholesale_transaction_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleTransactionRepository implements WholesaleTransactionRepositoryInterface {
  final DioClient? dioClient;
  WholesaleTransactionRepository({required this.dioClient});

  @override
  Future<ApiResponse> getTransactionList(String status, String from, String to, int offset) async {
    try {
      final Response response = await dioClient!.get(AppConstants.wholesaleTransactionUri, queryParameters: {
        'status': status,
        if (from.isNotEmpty) 'from': from,
        if (to.isNotEmpty) 'to': to,
        'limit': 10,
        'offset': offset,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) => throw UnimplementedError();

  @override
  Future delete(int id) => throw UnimplementedError();

  @override
  Future get(String id) => throw UnimplementedError();

  @override
  Future getList({int? offset = 1}) => throw UnimplementedError();

  @override
  Future update(Map<String, dynamic> body, int id) => throw UnimplementedError();
}
