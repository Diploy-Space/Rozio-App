import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/transaction/domain/models/transaction_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/transaction/domain/services/wholesale_transaction_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class WholesaleTransactionController extends ChangeNotifier {
  final WholesaleTransactionServiceInterface wholesaleTransactionServiceInterface;

  WholesaleTransactionController({required this.wholesaleTransactionServiceInterface});

  List<TransactionModel>? _transactionList;
  List<TransactionModel>? get transactionList => _transactionList;

  int _transactionTypeIndex = 0;
  int get transactionTypeIndex => _transactionTypeIndex;

  int? _transactionTotalSize;
  int? get transactionTotalSize => _transactionTotalSize;
  int? _transactionOffset;
  int? get transactionOffset => _transactionOffset;
  String _status = 'all';
  String _from = '';
  String _to = '';

  static const List<String> _statusByIndex = ['all', 'pending', 'approve', 'deny'];

  void setIndex(BuildContext context, int index) {
    _transactionTypeIndex = index;
    getTransactionList(context, _statusByIndex[index], '', '');
    notifyListeners();
  }

  Future<void> getTransactionList(BuildContext context, String status, String from, String to, {int offset = 1}) async {
    if(offset == 1) {
      _status = status;
      _from = from;
      _to = to;
      _transactionList = null;
    }

    final String requestStatus = _status;
    ApiResponse apiResponse = await wholesaleTransactionServiceInterface.getTransactionList(_status, _from, _to, offset);
    if(requestStatus != _status) {
      return;
    }

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final ApiListEnvelope envelope = ApiListEnvelope.fromJson(apiResponse.response!.data);
      final List<TransactionModel> transactions = envelope.data?.map((transaction) => TransactionModel.fromJson(transaction)).toList() ?? [];

      if(offset == 1 || _transactionList == null) {
        _transactionList = transactions;
      } else {
        _transactionList!.addAll(transactions);
      }
      _transactionTotalSize = envelope.totalSize;
      _transactionOffset = envelope.offset;
    } else {
      _transactionList ??= [];
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> loadMoreTransactions(BuildContext context, int offset) async {
    await getTransactionList(context, _status, _from, _to, offset: offset);
  }

  Future<void> refreshTransactionList(BuildContext context) async {
    await getTransactionList(context, _status, _from, _to);
  }
}
