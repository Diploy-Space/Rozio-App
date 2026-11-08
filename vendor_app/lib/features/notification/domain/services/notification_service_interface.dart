

abstract class NotificationServiceInterface {
  Future<dynamic> getNotificationList(int offset);
  Future<dynamic> seenNotification(int id);
  Future<dynamic> getAuctionNotificationList({int limit = 10, int offset = 1});
  Future<dynamic> markAuctionNotificationSeen({int? id});
  Future<dynamic> getWholesaleNotificationList({int limit = 10, int offset = 1});
  Future<dynamic> markWholesaleNotificationSeen({required int id});
}