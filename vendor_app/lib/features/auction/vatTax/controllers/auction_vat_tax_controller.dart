import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/tax_vat_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/tax_vat_setup_model.dart';
import 'package:sixvalley_vendor_app/features/auction/vatTax/domain/services/auction_vat_tax_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class AuctionVatTaxController with ChangeNotifier {
  final AuctionVatTaxServiceInterface auctionVatTaxServiceInterface;
  AuctionVatTaxController({required this.auctionVatTaxServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TaxVatSetupModel? _setup;
  TaxVatSetupModel? get setup => _setup;

  bool get isTaxSelectable => (_setup?.isProductWise ?? false) && !(_setup?.isIncluded ?? false);

  List<TaxVatModel> _taxList = [];
  List<TaxVatModel> get taxList => _taxList;

  final List<TaxVatModel> _selectedTaxList = [];
  List<TaxVatModel> get selectedTaxList => _selectedTaxList;

  Future<void> getVatTaxSetup({bool reload = false}) async {
    if (!reload && _setup != null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    final ApiResponse setupResponse = await auctionVatTaxServiceInterface.getSetup();

    if (setupResponse.response != null && setupResponse.response!.statusCode == 200) {
      _setup = TaxVatSetupModel.fromJson(ApiEnvelope.content(setupResponse.response?.data) as Map<String, dynamic>);
    } else {
      _setup = TaxVatSetupModel();
      ApiChecker.checkApi(setupResponse);
    }

    if (isTaxSelectable) {
      await _fetchTaxList();
    } else {
      _taxList = [];
      _selectedTaxList.clear();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchTaxList() async {
    _taxList = [];
    final ApiResponse response = await auctionVatTaxServiceInterface.getTaxList();

    if (response.response != null && response.response!.statusCode == 200) {
      final dynamic taxes = ApiEnvelope.content(response.response?.data)['data'];
      if (taxes is List) {
        for (final dynamic tax in taxes) {
          _taxList.add(TaxVatModel.fromJson(tax));
        }
      }

      if (_taxList.isNotEmpty) {
        _taxList.insert(0, TaxVatModel(id: 0, name: 'All'));
      }
    } else {
      _taxList = [];
      ApiChecker.checkApi(response);
    }
  }

  bool isSelected(TaxVatModel tax) {
    return _selectedTaxList.any((selected) => selected.id == tax.id);
  }

  void addToSelectedTaxList(TaxVatModel tax) {
    if (tax.id == null || tax.id == 0 || isSelected(tax)) {
      return;
    }
    _selectedTaxList.add(tax);
    notifyListeners();
  }

  void removeFromSelectedTaxList(int index) {
    _selectedTaxList.removeAt(index);
    notifyListeners();
  }
}
