import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class ShippingTypeHost implements ChangeNotifier {
  int get shippingIndex;
  void setShippingType(int index);
  Future<void> getSelectedShippingMethodType(BuildContext context);
  Future<ApiResponse> setShippingMethodType(BuildContext context, String? type);
}
