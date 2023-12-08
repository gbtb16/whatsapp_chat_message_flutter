import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_render_object_example/whatsapp_chat_message/whatsapp_chat_message.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static TextStyle get _textStyle => const TextStyle(color: Colors.white);
  static TextStyle get _sentAtTextStyle => TextStyle(color: Colors.blueGrey[200]!);

  final TextEditingController _controller = TextEditingController();
  final MessagesController _messagesController = MessagesController();

  @override
  void initState() {
    super.initState();

    const minutesDuration = Duration(minutes: 1);

    Timer.periodic(minutesDuration, (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _messagesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ListenableBuilder(
              listenable: _messagesController,
              builder: (context, widget) {
                if (_messagesController.messages.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _messagesController.messages.length,
                      itemBuilder: (context, index) {
                        final Message message = _messagesController.messages[index];
                        final bool isLastIndex = (index == _messagesController.messages.length - 1);

                        return Container(
                          margin: EdgeInsets.only(bottom: (isLastIndex) ? 0 : 10, right: 16),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: WhatsappChatMessage(
                            messageText: message.text,
                            sentAtText: message.sentAtToText,
                            textStyle: _textStyle,
                            sentAtTextStyle: _sentAtTextStyle,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Divider(height: 0),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) {
                    _messagesController.addMessage(
                      Message(
                        text: _controller.text,
                        sentAt: DateTime.now(),
                      ),
                    );

                    _controller.clear();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
