import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/auction/domain/models/auction_home_stats_model.dart';
import 'package:sixvalley_vendor_app/features/auction/domain/services/auction_home_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class AuctionHomeController with ChangeNotifier {
  final AuctionHomeServiceInterface serviceInterface;
  AuctionHomeController({required this.serviceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isInitialLoading = true;
  bool get isInitialLoading => _isInitialLoading;

  Future<void> loadData({bool reload = false}) async {
    _isLoading = true;
    if (reload) {
      notifyListeners();
    }

    await Future.wait([
      getBusinessAnalyticsData(),
      getBidAnalyticsData(),
      getEarningStatistics(),
      getTopPerformingAuctions(),
      getRecentlyEndedAuctions(),
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

  AuctionBusinessAnalyticsModel? _businessAnalyticsData;
  AuctionBusinessAnalyticsModel get businessAnalyticsData => _businessAnalyticsData ?? AuctionBusinessAnalyticsModel.empty;

  Future<void> getBusinessAnalyticsData() async {
    final int filterIndex = _analyticsFilterIndex;
    final ApiResponse apiResponse = await serviceInterface.getAuctionStatistics(_analyticsDateTypes[filterIndex]);
    if (filterIndex != _analyticsFilterIndex) {
      return;
    }

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _businessAnalyticsData = AuctionBusinessAnalyticsModel.fromJson(ApiEnvelope.dataObject(apiResponse.response!.data));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  AuctionBidAnalyticsModel? _bidAnalyticsData;
  AuctionBidAnalyticsModel get bidAnalyticsData => _bidAnalyticsData ?? AuctionBidAnalyticsModel.empty;

  Future<void> getBidAnalyticsData() async {
    final ApiResponse apiResponse = await serviceInterface.getBidStatistics();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _bidAnalyticsData = AuctionBidAnalyticsModel.fromJson(ApiEnvelope.dataObject(apiResponse.response!.data));
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

  List<double>? _grossSales;
  List<double>? get grossSales => _grossSales;

  List<double>? _commissionGiven;
  List<double>? get commissionGiven => _commissionGiven;

  Future<void> getEarningStatistics() async {
    final int filterIndex = _revenueFilterIndex;
    final ApiResponse apiResponse = await serviceInterface.getEarningStatistics(_revenueTypes[filterIndex]);
    if (filterIndex != _revenueFilterIndex) {
      return;
    }

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final Map statistics = ApiEnvelope.dataObject(apiResponse.response!.data);
      _grossSales = _toAmounts(statistics['gross_sales']);
      _commissionGiven = _toAmounts(statistics['commission_given']);
    } else {
      _grossSales ??= [];
      _commissionGiven ??= [];
    }
    notifyListeners();
  }

  static List<double> _toAmounts(dynamic values) {
    return values is List ? values.map((value) => double.tryParse('$value') ?? 0).toList() : [];
  }

  List<AuctionTopPerformingModel>? _topPerformingAuctions;
  List<AuctionTopPerformingModel>? get topPerformingAuctions => _topPerformingAuctions;

  Future<void> getTopPerformingAuctions() async {
    final ApiResponse apiResponse = await serviceInterface.getTopPerformingAuctions(offset: 1);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _topPerformingAuctions = ApiListEnvelope.fromJson(apiResponse.response!.data).data
        ?.whereType<Map>()
        .map((row) => AuctionTopPerformingModel.fromJson(row))
        .toList() ?? [];
    } else {
      _topPerformingAuctions ??= [];
    }
    notifyListeners();
  }

  List<AuctionRecentlyEndedModel>? _recentlyEndedAuctions;
  List<AuctionRecentlyEndedModel>? get recentlyEndedAuctions => _recentlyEndedAuctions;

  Future<void> getRecentlyEndedAuctions() async {
    final ApiResponse apiResponse = await serviceInterface.getRecentlyEndedAuctions(offset: 1);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _recentlyEndedAuctions = ApiListEnvelope.fromJson(apiResponse.response!.data).data
        ?.whereType<Map>()
        .map((row) => AuctionRecentlyEndedModel.fromJson(row))
        .toList() ?? [];
    } else {
      _recentlyEndedAuctions ??= [];
    }
    notifyListeners();
  }
}
