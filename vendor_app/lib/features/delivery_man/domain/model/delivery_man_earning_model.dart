
import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_detail_model.dart';

class DeliveryManEarningModel {
  int? totalSize;
  String? limit;
  String? offset;
  double? totalEarn;
  double? withdrawableBalance;
  DeliveryMan? deliveryMan;
  List<Earning>? orders;

  DeliveryManEarningModel(
      {this.totalSize,
        this.limit,
        this.offset,
        this.totalEarn,
        this.withdrawableBalance,
        this.deliveryMan,
        this.orders});

  DeliveryManEarningModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['orders']);
    totalSize = envelope.totalSize;
    limit = envelope.limit?.toString();
    offset = envelope.offset?.toString();
    totalEarn = double.tryParse('${envelope.read('total_earn')}');
    withdrawableBalance = double.tryParse('${envelope.read('withdrawable_balance')}');
    deliveryMan = envelope.read('delivery_man') != null ? DeliveryMan.fromJson(envelope.read('delivery_man')) : null;
    orders = envelope.data?.map((v) => Earning.fromJson(v)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    data['total_earn'] = totalEarn;
    data['withdrawable_balance'] = withdrawableBalance;
    if (deliveryMan != null) {
      data['delivery_man'] = deliveryMan!.toJson();
    }
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



class Earning {
  int? id;
  double? deliverymanCharge;
  String? orderStatus;
  int? deliveryManId;
  String? updatedAt;

  Earning(
      {this.id,
        this.deliverymanCharge,
        this.orderStatus,
        this.deliveryManId,
        this.updatedAt});

  Earning.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if(json['deliveryman_charge'] != null){
      try{
        deliverymanCharge = json['deliveryman_charge'].toDouble();
      }catch(e){
        deliverymanCharge = double.parse(json['deliveryman_charge'].toString());
      }

    }

    orderStatus = json['order_status'];
    deliveryManId = int.parse(json['delivery_man_id'].toString());
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deliveryman_charge'] = deliverymanCharge;
    data['order_status'] = orderStatus;
    data['delivery_man_id'] = deliveryManId;
    data['updated_at'] = updatedAt;
    return data;
  }
}
