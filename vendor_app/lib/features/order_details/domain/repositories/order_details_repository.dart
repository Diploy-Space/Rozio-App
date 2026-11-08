import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/models/order_setup_model.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/repositories/order_details_repository_interface.dart';
import 'package:sixvalley_vendor_app/helper/order_helper.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class OrderDetailsRepository implements OrderDetailsRepositoryInterface{
  final DioClient? dioClient;
  OrderDetailsRepository({required this.dioClient});


  @override
  Future<ApiResponse> getOrderStatusList(String type) async {
    try {
      Response response = Response(requestOptions: RequestOptions(path: ''), data: OrderHelper.statusListFor(type), statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getOrderDetails(String orderID) async {
    try {
      final response = await dioClient!.get('${AppConstants.orderDetails}$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> uploadAfterSellDigitalProduct(File? filePath, String token, String orderId, String orderDetailId) async {
    try {
      final List<MultipartWithKey> files = [];

      if(filePath != null) {
        files.add(MultipartWithKey(
          key: 'digital_file_after_sell',
          multipartFile: await MultipartFile.fromFile(filePath.path, filename: basename(filePath.path)),
        ));
      }

      final response = await dioClient!.postMultipart(
        '${AppConstants.digitalProductUploadAfterSell}/$orderId/digital-files',
        data: {'order_detail_id': orderDetailId},
        files: files,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }


  @override
  Future<HttpClientResponse> productDownload(String? url) async {
    HttpClient client = HttpClient();
    final response = await client.getUrl(Uri.parse(url!)).then((HttpClientRequest request) {
      return request.close();
    },
    );
    return response;
  }

  @override
  Future<ApiResponse> setUpOrder(OrderSetupModel orderSetUpModel) async {
    try {
      Response response = await dioClient!.put('${AppConstants.setUpOrder}/${orderSetUpModel.orderId}/items',
        data: orderSetUpModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future getOrderInvoice(String orderID) async{
    try {
      final response = await dioClient!.get('${AppConstants.generateInvoice}/$orderID/invoice',
        options: Options(responseType: ResponseType.bytes),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}