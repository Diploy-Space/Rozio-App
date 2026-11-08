import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/auction/domain/repository/auction_transaction_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class AuctionTransactionRepository implements AuctionTransactionRepositoryInterface {
  final DioClient? dioClient;
  AuctionTransactionRepository({required this.dioClient});

  @override
  Future<ApiResponse> getAuctionTransactionList({
    int? searchAuctionId,
    int limit = 10,
    int offset = 1,
    List<String>? transactionTypes,
    String? filterDurationType,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'limit': limit,
        'offset': offset,
        if (searchAuctionId != null) 'search': searchAuctionId.toString(),
        if (_durationType(filterDurationType) != null) 'duration_type': _durationType(filterDurationType),
        if (filterDurationType == 'custom_date' && startDate != null) 'start_date': startDate,
        if (filterDurationType == 'custom_date' && endDate != null) 'end_date': endDate,
      };

      if (transactionTypes != null && transactionTypes.isNotEmpty) {
        queryParams['entry_type[]'] = transactionTypes;
      }

      final response = await dioClient!.get(
        AppConstants.auctionTransactionHistoryUri,
        queryParameters: queryParams,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  String? _durationType(String? filterDurationType) {
    switch (filterDurationType) {
      case 'today': return 'today';
      case 'this_month': return 'month';
      case 'this_year': return 'year';
      case 'custom_date': return 'custom';
      default: return null;
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
