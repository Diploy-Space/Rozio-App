abstract class TransactionServiceInterface {
  Future<dynamic> getTransactionList(String status, String from, String to, int offset);
  Future<dynamic> getMonthTypeList();
  Future<dynamic> getYearList();
}