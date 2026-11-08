import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class WholesaleTransactionRepositoryInterface implements RepositoryInterface {
  Future<ApiResponse> getTransactionList(String status, String from, String to, int offset);
}
