abstract class Notification {
  Notification({required this.title, required this.message});
  String title;
  String message;
}

class Suggest extends Notification {
  Suggest({required String title, required String message, required this.type})
      : super(title: title, message: message);
  final SuggestNotificationType type;
}

enum SuggestNotificationType { news, hotNews, live, localNews }

class ServerNotification extends Notification {
  ServerNotification(
      {required String title, required String message, required this.type})
      : super(title: title, message: message);
  final ServerNotificationType type;
}

enum ServerNotificationType { payment, newComment, votingResult }

Suggest notifications = Suggest(
    message: 'hello', title: '1234', type: SuggestNotificationType.localNews);
