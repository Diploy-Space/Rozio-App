import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatTax/domain/models/wholesale_vat_tax_setup_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatTax/domain/services/wholesale_vat_tax_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class WholesaleVatTaxController with ChangeNotifier {
  final WholesaleVatTaxServiceInterface wholesaleVatTaxServiceInterface;
  WholesaleVatTaxController({required this.wholesaleVatTaxServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  WholesaleVatTaxSetupModel? _setup;
  WholesaleVatTaxSetupModel? get setup => _setup;

  List<WholesaleTaxModel> _taxList = [];
  List<WholesaleTaxModel> get taxList => _taxList;

  final List<WholesaleTaxModel> _selectedTaxList = [];
  List<WholesaleTaxModel> get selectedTaxList => _selectedTaxList;

  bool get isTaxSelectable => (_setup?.isProductWise ?? false) && !(_setup?.isIncluded ?? false);

  Future<void> getVatTaxSetup({bool reload = false, bool isUpdate = true}) async {
    if (!reload && _setup != null) {
      return;
    }

    _isLoading = true;
    if (isUpdate) {
      notifyListeners();
    }

    final ApiResponse setupResponse = await wholesaleVatTaxServiceInterface.getSetup();

    if (setupResponse.response != null && setupResponse.response!.statusCode == 200) {
      _setup = WholesaleVatTaxSetupModel.fromJson(setupResponse.response!.data);
    } else {
      _setup = WholesaleVatTaxSetupModel();
      ApiChecker.checkApi(setupResponse);
    }

    if (isTaxSelectable) {
      await _getTaxList();
    } else {
      _taxList = [];
      _selectedTaxList.clear();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _getTaxList() async {
    _taxList = [];
    final ApiResponse apiResponse = await wholesaleVatTaxServiceInterface.getTaxList();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic taxes = ApiEnvelope.content(apiResponse.response?.data)['data'];
      if (taxes is List) {
        for (final dynamic tax in taxes) {
          _taxList.add(WholesaleTaxModel.fromJson(tax));
        }
      }

      if (_taxList.isNotEmpty) {
        _taxList.insert(0, WholesaleTaxModel(id: 0, name: 'All'));
      }
    } else {
      _taxList = [];
      ApiChecker.checkApi(apiResponse);
    }
  }

  bool isSelected(WholesaleTaxModel tax) {
    return _selectedTaxList.any((selected) => selected.id == tax.id);
  }

  void addToSelectedTaxList(WholesaleTaxModel tax) {
    if (tax.id == null || tax.id == 0 || isSelected(tax)) {
      return;
    }
    _selectedTaxList.add(tax);
    notifyListeners();
  }

  void selectAllTaxes() {
    for (final WholesaleTaxModel tax in _taxList) {
      if (tax.id != null && tax.id != 0 && !isSelected(tax)) {
        _selectedTaxList.add(tax);
      }
    }
    notifyListeners();
  }

  void selectTaxesByIds(List<int> taxIds) {
    _selectedTaxList.clear();

    if (isTaxSelectable) {
      for (final int id in taxIds) {
        for (final WholesaleTaxModel tax in _taxList) {
          if (tax.id == id && id != 0) {
            _selectedTaxList.add(tax);
            break;
          }
        }
      }
    }

    notifyListeners();
  }

  void removeFromSelectedTaxList(int index) {
    _selectedTaxList.removeAt(index);
    notifyListeners();
  }

  List<int> get selectedTaxIds {
    if (!isTaxSelectable) {
      return [];
    }
    return _selectedTaxList.where((tax) => tax.id != null && tax.id != 0).map((tax) => tax.id!).toList();
  }

  void clearSelection({bool notify = true}) {
    _selectedTaxList.clear();
    if (notify) {
      notifyListeners();
    }
  }
}
