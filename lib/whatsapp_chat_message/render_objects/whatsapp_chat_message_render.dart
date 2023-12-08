import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WhatsappChatMessageRenderObject extends RenderBox {
  late String _messageText;
  late String _sentAtText;
  late TextStyle _textStyle;
  late TextStyle? _sentAtTextStyle;
  late TextDirection _textDirection;

  late TextPainter _textPainter;
  late TextPainter _sentAtTextPainter;

  WhatsappChatMessageRenderObject({
    required String messageText,
    required String sentAtText,
    required TextStyle textStyle,
    TextStyle? sentAtTextStyle,
    required TextDirection textDirection,
  }) {
    _messageText = messageText;
    _sentAtText = sentAtText;
    _textStyle = textStyle;
    _sentAtTextStyle = sentAtTextStyle;
    _textDirection = textDirection;

    _textPainter = TextPainter(
      text: textSpan,
      textDirection: _textDirection,
    );

    _sentAtTextPainter = TextPainter(
      text: sentAtTextSpan,
      textDirection: _textDirection,
    );
  }

  TextSpan get textSpan => TextSpan(text: _messageText, style: _textStyle);
  TextSpan get sentAtTextSpan => TextSpan(text: _sentAtText, style: _sentAtTextStyle ?? _textStyle.copyWith(color: Colors.grey));

  String get text => _messageText;
  set text(String newText) {
    if (_messageText == newText) {
      return;
    }

    _messageText = newText;

    _textPainter.text = textSpan;

    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  String get sentAt => _sentAtText;
  set sentAt(String newSentAt) {
    if (_sentAtText == newSentAt) {
      return;
    }

    _sentAtText = newSentAt;

    _sentAtTextPainter.text = sentAtTextSpan;

    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  TextStyle get textStyle => _textStyle;
  set textStyle(TextStyle newTextStyle) {
    if (_textStyle == newTextStyle) {
      return;
    }

    _textStyle = newTextStyle;

    _textPainter.text = textSpan;
    _sentAtTextPainter.text = sentAtTextSpan;

    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  TextStyle? get sentAtTextStyle => _sentAtTextStyle;
  set sentAtTextStyle(TextStyle? newSentAtTextStyle) {
    if (_sentAtTextStyle == newSentAtTextStyle) {
      return;
    }

    _sentAtTextStyle = newSentAtTextStyle;

    _textPainter.text = textSpan;
    _sentAtTextPainter.text = sentAtTextSpan;

    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection newTextDirection) {
    if (textDirection == newTextDirection) {
      return;
    }

    _textDirection = newTextDirection;

    _textPainter.textDirection = _textDirection;
    _sentAtTextPainter.textDirection = _textDirection;

    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  // [perfomLayout] values which will be used by [paint]
  late bool _sentAtFitsOnLastLine;
  late double _messageLineHeight;
  late double _lastMessageLineWidth;
  late double _longestLineWidth;
  late double _sentAtLineWidth;
  late int _messageLinesLength;

  static const int paddingTopLastLineWithDate = 20;

  @override
  void performLayout() {
    // Layout and set size to [messageText]
    _textPainter.layout(maxWidth: constraints.maxWidth);
    final textLines = _textPainter.computeLineMetrics();

    _longestLineWidth = textLines.map((textLine) => textLine.width).reduce(max);
    _lastMessageLineWidth = textLines.last.width;
    _messageLineHeight = textLines.last.height;
    _messageLinesLength = textLines.length;

    final sizeOfMessage = Size(_longestLineWidth, _textPainter.height);

    // Layout and set size to [sentAtText]
    _sentAtTextPainter.layout(maxWidth: constraints.maxWidth);
    _sentAtLineWidth = _sentAtTextPainter.computeLineMetrics().first.width;

    // Set [_sentAtFitsOnLastLine]
    final lastLineWithDateWidth = _lastMessageLineWidth + (_sentAtLineWidth + 8);

    if (_messageLinesLength == 1) {
      _sentAtFitsOnLastLine = (lastLineWithDateWidth < constraints.maxWidth);
    } else {
      _sentAtFitsOnLastLine = (lastLineWithDateWidth < min(_longestLineWidth, constraints.maxWidth));
    }

    // Set widget size
    late Size computedSize;

    if (!_sentAtFitsOnLastLine) {
      computedSize = Size(
        sizeOfMessage.width,
        sizeOfMessage.height + _sentAtTextPainter.height,
      );
    } else {
      final messageHeight = sizeOfMessage.height;

      if (_messageLinesLength == 1) {
        computedSize = Size(lastLineWithDateWidth, messageHeight);
      } else {
        computedSize = Size(_longestLineWidth, messageHeight + paddingTopLastLineWithDate);
      }
    }

    size = constraints.constrain(computedSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Painting [messageText] - Offset at start
    _textPainter.paint(context.canvas, offset);

    // Painting [sentAtText] - Depends on message line height and width
    late Offset sentAtOffset;

    if (_sentAtFitsOnLastLine) {
      sentAtOffset = Offset(
        offset.dx + (size.width - _sentAtLineWidth),
        offset.dy + (_messageLineHeight * (_messageLinesLength - 1)),
      );

      if (_messageLinesLength > 1) {
        sentAtOffset = Offset(sentAtOffset.dx, sentAtOffset.dy + paddingTopLastLineWithDate);
      }
    } else {
      sentAtOffset = Offset(
        offset.dx + (size.width - _sentAtLineWidth),
        offset.dy + (_messageLineHeight * _messageLinesLength),
      );
    }

    _sentAtTextPainter.paint(context.canvas, sentAtOffset);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config.isSemanticBoundary = true;
    config.label = '$_messageText, sent at $_sentAtText';
    config.textDirection = _textDirection;
  }
}
