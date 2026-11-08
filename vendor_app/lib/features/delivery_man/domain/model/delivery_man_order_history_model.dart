import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';

class DeliveryManOrderHistoryModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<Order>? orders;

  DeliveryManOrderHistoryModel(
      {this.totalSize, this.limit, this.offset, this.orders});

  DeliveryManOrderHistoryModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['orders']);
    totalSize = envelope.totalSize;
    limit = envelope.limit?.toString();
    offset = envelope.offset?.toString();
    orders = envelope.data?.map((v) => Order.fromJson(v)).toList();
  }

}


