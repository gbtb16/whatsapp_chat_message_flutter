import 'package:uuid/uuid.dart';

class Message {
  final String id;
  final String text;
  final DateTime sentAt;

  Message({
    String? id,
    required this.text,
    required this.sentAt,
  }) : id = id ?? const Uuid().v4();

  String get sentAtToText {
    final DateTime now = DateTime.now();
    final int secondsToNow = now.second - sentAt.second;
    final int minutesToNow = now.minute - sentAt.minute;

    late String sentAtText;

    if (minutesToNow < 1) {
      if (secondsToNow < 1) {
        sentAtText = 'now';
      } else {
        sentAtText = 'less than a minute';
      }
    } else if (minutesToNow == 1) {
      sentAtText = '1 minute ago';
    } else {
      sentAtText = '$minutesToNow minutes ago';
    }

    return sentAtText;
  }

  Message copyWith({
    String? text,
    DateTime? sentAt,
  }) {
    return copyWith(
      text: text ?? this.text,
      sentAt: sentAt ?? this.sentAt,
    );
  }
}
