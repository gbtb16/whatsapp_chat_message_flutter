import 'package:flutter/material.dart';
import 'package:simple_render_object_example/whatsapp_chat_message/render_objects/whatsapp_chat_message_render.dart';

class WhatsappChatMessage extends LeafRenderObjectWidget {
  final String messageText;
  final String sentAtText;
  final TextStyle textStyle;
  final TextStyle? sentAtTextStyle;

  const WhatsappChatMessage({
    super.key,
    required this.messageText,
    required this.sentAtText,
    required this.textStyle,
    this.sentAtTextStyle,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return WhatsappChatMessageRenderObject(
      messageText: messageText,
      sentAtText: sentAtText,
      textStyle: textStyle,
      sentAtTextStyle: sentAtTextStyle,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, WhatsappChatMessageRenderObject renderObject) {
    renderObject.text = messageText;
    renderObject.sentAt = sentAtText;
    renderObject.textStyle = textStyle;
    renderObject.sentAtTextStyle = sentAtTextStyle;
    renderObject.textDirection = Directionality.of(context);
  }
}
