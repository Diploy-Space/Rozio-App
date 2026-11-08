import 'package:sixvalley_vendor_app/data/model/pagination_model.dart';

class WholesaleAttributeModel {
  int? id;
  String? name;

  WholesaleAttributeModel({this.id, this.name});

  WholesaleAttributeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class WholesaleAttributeListModel {
  List<WholesaleAttributeModel> attributes;
  PaginationModel? pagination;

  WholesaleAttributeListModel({List<WholesaleAttributeModel>? attributes, this.pagination}) : attributes = attributes ?? [];

  WholesaleAttributeListModel.fromJson(Map<String, dynamic> json) : attributes = [] {
    final dynamic content = json['content'];
    if (content == null) {
      return;
    }

    if (content['data'] != null) {
      for (final dynamic attribute in content['data']) {
        attributes.add(WholesaleAttributeModel.fromJson(attribute));
      }
    }

    if (content['pagination'] != null) {
      pagination = PaginationModel.fromJson(content['pagination']);
    }
  }
}
