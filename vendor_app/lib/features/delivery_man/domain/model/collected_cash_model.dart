import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';

class CollectedCashModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<CollectedCash>? collectedCash;

  CollectedCashModel(
      {this.totalSize, this.limit, this.offset, this.collectedCash});

  CollectedCashModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['collected_cash']);
    totalSize = envelope.totalSize;
    limit = envelope.limit?.toString();
    offset = envelope.offset?.toString();
    collectedCash = envelope.data?.map((v) => CollectedCash.fromJson(v)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (collectedCash != null) {
      data['collected_cash'] =
          collectedCash!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CollectedCash {
  int? id;
  String? credit;
  String? transactionType;
  String? createdAt;
  String? updatedAt;

  CollectedCash(
      {this.id,
        this.credit,
        this.transactionType,
        this.createdAt,
        this.updatedAt});

  CollectedCash.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    credit = json['credit'].toString();
    transactionType = json['transaction_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['credit'] = credit;
    data['transaction_type'] = transactionType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
