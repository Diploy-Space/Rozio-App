import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/domain/models/wholesale_top_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/domain/services/wholesale_home_service_interface.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/business_analytics_filter_data.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class WholesaleHomeController with ChangeNotifier {
  final WholesaleHomeServiceInterface wholesaleHomeServiceInterface;
  WholesaleHomeController({required this.wholesaleHomeServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isInitialLoading = true;
  bool get isInitialLoading => _isInitialLoading;

  Future<void> loadData({bool reload = false}) async {
    _isLoading = true;
    if(reload) {
      notifyListeners();
    }

    await Future.wait([
      getBusinessAnalyticsData(),
      getEarningStatistics(),
      getTopSellingProducts(),
      getMostPopularProducts(),
    ]);
    _isLoading = false;
    _isInitialLoading = false;
    notifyListeners();
  }

  static const List<String?> _analyticsDateTypes = [null, 'today', 'this_week', 'this_month', 'this_year'];

  int _analyticsFilterIndex = 3;
  int get analyticsFilterIndex => _analyticsFilterIndex;

  void setAnalyticsFilterIndex(int index) {
    _analyticsFilterIndex = index;
    notifyListeners();
    getBusinessAnalyticsData();
  }

  BusinessAnalyticsFilterDataModel? _businessAnalyticsFilterData;
  BusinessAnalyticsFilterDataModel get businessAnalyticsFilterData => _businessAnalyticsFilterData ?? BusinessAnalyticsFilterDataModel();

  Future<void> getBusinessAnalyticsData() async {
    final ApiResponse apiResponse = await wholesaleHomeServiceInterface.getOrderStatusCounts(_analyticsDateTypes[_analyticsFilterIndex]);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _businessAnalyticsFilterData = BusinessAnalyticsFilterDataModel.fromJson(Map<String, dynamic>.from(ApiEnvelope.dataObject(apiResponse.response!.data)));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  static const List<String> _revenueTypes = ['yearEarn', 'MonthEarn', 'WeekEarn'];

  int _revenueFilterIndex = 1;
  int get revenueFilterIndex => _revenueFilterIndex;

  void setRevenueFilterIndex(int index) {
    _revenueFilterIndex = index;
    notifyListeners();
    getEarningStatistics();
  }

  List<double>? _earnings;
  List<double>? get earnings => _earnings;

  List<double>? _commissions;
  List<double>? get commissions => _commissions;

  Future<void> getEarningStatistics() async {
    final int filterIndex = _revenueFilterIndex;
    final ApiResponse apiResponse = await wholesaleHomeServiceInterface.getEarningStatistics(_revenueTypes[filterIndex]);
    if (filterIndex != _revenueFilterIndex) {
      return;
    }

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final Map statistics = ApiEnvelope.dataObject(apiResponse.response!.data);
      _earnings = _toAmounts(statistics['seller_earn']);
      _commissions = _toAmounts(statistics['commission_earn']);
    } else {
      _earnings ??= [];
      _commissions ??= [];
    }
    notifyListeners();
  }

  static List<double> _toAmounts(dynamic values) {
    return values is List ? values.map((value) => double.tryParse('$value') ?? 0).toList() : [];
  }

  List<WholesaleTopProductModel>? _topSellingProducts;
  List<WholesaleTopProductModel>? get topSellingProducts => _topSellingProducts;

  List<WholesaleTopProductModel>? _mostPopularProducts;
  List<WholesaleTopProductModel>? get mostPopularProducts => _mostPopularProducts;

  Future<void> getTopSellingProducts() async {
    final ApiResponse apiResponse = await wholesaleHomeServiceInterface.getTopSellingProducts(offset: 1);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _topSellingProducts = ApiListEnvelope.fromJson(apiResponse.response!.data).data
        ?.whereType<Map>()
        .map((row) => WholesaleTopProductModel.fromTopSellingJson(Map<String, dynamic>.from(row)))
        .toList() ?? [];
    } else {
      _topSellingProducts ??= [];
    }
    notifyListeners();
  }

  Future<void> getMostPopularProducts() async {
    final ApiResponse apiResponse = await wholesaleHomeServiceInterface.getMostPopularProducts(offset: 1);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _mostPopularProducts = ApiListEnvelope.fromJson(apiResponse.response!.data).data
        ?.whereType<Map>()
        .map((row) => WholesaleTopProductModel.fromMostPopularJson(Map<String, dynamic>.from(row)))
        .toList() ?? [];
    } else {
      _mostPopularProducts ??= [];
    }
    notifyListeners();
  }
}
