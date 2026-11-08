import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatReport/domain/repositories/wholesale_vat_report_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleVatReportRepository implements WholesaleVatReportRepositoryInterface {
  final DioClient? dioClient;
  WholesaleVatReportRepository({required this.dioClient});

  @override
  Future<ApiResponse> getVatReport(int? limit, int? offset, String? startDate, String? endDate) async {
    final Map<String, dynamic> queryParameters = {'limit': limit, 'offset': offset};

    if (startDate != null && endDate != null && startDate != 'null' && endDate != 'null') {
      queryParameters.addAll({'start_date': startDate, 'end_date': endDate});
    }

    try {
      final response = await dioClient!.get(AppConstants.wholesaleVatTaxReportList, queryParameters: queryParameters);
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
