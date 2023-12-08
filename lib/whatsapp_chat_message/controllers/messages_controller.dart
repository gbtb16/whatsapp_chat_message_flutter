import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:simple_render_object_example/whatsapp_chat_message/models/message.dart';

class MessagesController extends ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => _messages;
  set messages(List<Message> newMessages) {
    if (_messages == newMessages) {
      return;
    }

    _messages
      ..clear()
      ..addAll(newMessages);
    notifyListeners();
  }

  void addMessage(Message newMessage) {
    _messages.add(newMessage);
    notifyListeners();
  }

  void removeMessage(Message message) {
    final existingMessage = _messages.firstWhereOrNull((msg) => msg == message);

    if (existingMessage == null) {
      throw Exception('It\'s not possible remove a message that not exists in messages of controller.');
    }

    _messages.remove(existingMessage);
    notifyListeners();
  }
}
