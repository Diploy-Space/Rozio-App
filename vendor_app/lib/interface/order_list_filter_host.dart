import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/models/order_list_filter_model.dart';

abstract class OrderListFilterHost implements ChangeNotifier {
  OrderListFilterModel get filterModel;
  String get orderType;
  DateTime? get startDateFilter;
  DateTime? get endDateFilter;
  DateFormat get dateFormat;
  void selectFilterDate(String type, BuildContext context);
  void resetFilters({bool notify = true, bool refreshOrderList = true});
  Future<void> getOrderList(BuildContext? context, int offset, String status, OrderListFilterModel? filter, {bool reload = true});
}
