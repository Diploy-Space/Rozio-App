abstract class WholesaleTransactionServiceInterface {
  Future<dynamic> getTransactionList(String status, String from, String to, int offset);
}
