import 'package:sixvalley_vendor_app/features/wholesale/transaction/domain/repositories/wholesale_transaction_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/transaction/domain/services/wholesale_transaction_service_interface.dart';

class WholesaleTransactionService implements WholesaleTransactionServiceInterface {
  final WholesaleTransactionRepositoryInterface wholesaleTransactionRepoInterface;
  WholesaleTransactionService({required this.wholesaleTransactionRepoInterface});

  @override
  Future getTransactionList(String status, String from, String to, int offset) {
    return wholesaleTransactionRepoInterface.getTransactionList(status, from, to, offset);
  }
}
