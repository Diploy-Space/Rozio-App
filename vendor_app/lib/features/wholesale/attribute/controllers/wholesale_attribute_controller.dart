import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/attr.dart';
import 'package:sixvalley_vendor_app/features/wholesale/attribute/domain/models/wholesale_attribute_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/attribute/domain/services/wholesale_attribute_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class WholesaleAttributeController with ChangeNotifier {
  final WholesaleAttributeServiceInterface wholesaleAttributeServiceInterface;
  WholesaleAttributeController({required this.wholesaleAttributeServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<WholesaleAttributeModel>? _attributeList;
  List<WholesaleAttributeModel>? get attributeList => _attributeList;

  Future<void> getAttributeList({int limit = 200, int offset = 1, bool reload = false, bool isUpdate = true}) async {
    if (!reload && _attributeList != null && _attributeList!.isNotEmpty) {
      return;
    }

    _isLoading = true;
    if (isUpdate) {
      notifyListeners();
    }

    final ApiResponse apiResponse = await wholesaleAttributeServiceInterface.getAttributeList(limit: limit, offset: offset);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _attributeList = WholesaleAttributeListModel.fromJson(apiResponse.response!.data).attributes;
    } else {
      _attributeList = [];
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Attr> get variationAttributes {
    return (_attributeList ?? <WholesaleAttributeModel>[])
        .where((attribute) => attribute.id != null)
        .map((attribute) => Attr(id: attribute.id, name: attribute.name))
        .toList();
  }

  String? attributeNameOf(int? attributeId) {
    if (attributeId == null || _attributeList == null) {
      return null;
    }
    for (final WholesaleAttributeModel attribute in _attributeList!) {
      if (attribute.id == attributeId) {
        return attribute.name;
      }
    }
    return null;
  }
}
