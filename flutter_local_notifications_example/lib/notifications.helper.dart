import 'main.dart';

import 'notifications.dart';

class NotificationHelper extends HomePageState {
  void processNotification(type, payload) {
    switch (type) {
      case SuggestNotificationType.hotNews:
        break;
      case SuggestNotificationType.live:
        break;
      case SuggestNotificationType.localNews:
        break;
      case ServerNotificationType.newComment:
        break;
      case ServerNotificationType.payment:
        break;
      case ServerNotificationType.votingResult:
        break;
      default:
    }
  }
}

void processNotiPayment(payload) {
  // Perform processing for update payment notification
}
