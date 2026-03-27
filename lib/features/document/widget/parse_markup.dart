import 'package:flutter/material.dart';

class ParseMarkup extends StatelessWidget {
  const ParseMarkup({super.key, required this.text});
  final String text;

  TextStyle _baseStyle(Color color) =>
      TextStyle(color: color, height: 1.05, fontSize: 14);

  List<TextSpan> _parseInlineSpans(String text, TextStyle baseStyle) {
    final spans = <TextSpan>[];
    final buffer = StringBuffer();
    final stack = <TextStyle>[];

    TextStyle current = baseStyle;
    int i = 0;

    void flush() {
      if (buffer.isNotEmpty) {
        spans.add(TextSpan(text: buffer.toString(), style: current));
        buffer.clear();
      }
    }

    while (i < text.length) {
      if (text[i] == '[') {
        final end = text.indexOf(']', i);
        if (end == -1) {
          buffer.write(text[i++]);
          continue;
        }

        final tag = text.substring(i + 1, end);
        i = end + 1;

        if (tag == 'b') {
          flush();
          stack.add(current);
          current = current.copyWith(fontWeight: FontWeight.bold);
        } else if (tag == '/b') {
          flush();
          current = stack.isNotEmpty ? stack.removeLast() : baseStyle;
        } else if (tag == 'i') {
          flush();
          stack.add(current);
          current = current.copyWith(fontStyle: FontStyle.italic);
        } else if (tag == '/i') {
          flush();
          current = stack.isNotEmpty ? stack.removeLast() : baseStyle;
        } else {
          buffer.write('[$tag]');
        }
      } else {
        buffer.write(text[i++]);
      }
    }

    flush();
    return spans;
  }

  List<Widget> _parseListItems(String text, TextStyle baseStyle) {
    final items = <Widget>[];
    int i = 0;

    while (i < text.length) {
      if (text.startsWith('[li]', i)) {
        final start = i + 4;
        final end = text.indexOf('[/li]', start);

        if (end != -1) {
          final content = text.substring(start, end);

          items.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: baseStyle),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: _parseInlineSpans(content, baseStyle),
                        style: baseStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          i = end + 5;
          continue;
        }
      }
      i++;
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final color =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;

    final baseStyle = _baseStyle(color);

    final widgets = <Widget>[];
    final buffer = StringBuffer();

    List<TextSpan> spans = [];
    TextStyle currentStyle = baseStyle;

    int i = 0;

    void flush() {
      if (buffer.isNotEmpty) {
        spans.add(TextSpan(text: buffer.toString(), style: currentStyle));
        buffer.clear();
      }
    }

    void pushText() {
      flush();
      if (spans.isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: RichText(text: TextSpan(children: spans, style: baseStyle)),
          ),
        );
      }
      spans = [];
      currentStyle = baseStyle;
    }

    while (i < text.length) {
      if (text[i] == '[') {
        final end = text.indexOf(']', i);
        if (end == -1) {
          buffer.write(text[i++]);
          continue;
        }

        final tag = text.substring(i + 1, end);
        i = end + 1;

        if (tag == 'b') {
          flush();
          currentStyle = currentStyle.copyWith(fontWeight: FontWeight.bold);
        } else if (tag == '/b') {
          flush();
          currentStyle = currentStyle.copyWith(fontWeight: FontWeight.normal);
        } else if (tag == 'i') {
          flush();
          currentStyle = currentStyle.copyWith(fontStyle: FontStyle.italic);
        } else if (tag == '/i') {
          flush();
          currentStyle = currentStyle.copyWith(fontStyle: FontStyle.normal);
        } else if (tag.startsWith('h')) {
          flush();
          pushText();

          final close = text.indexOf('[/$tag]', i);
          if (close != -1) {
            final headingText = text.substring(i, close);

            i = close + tag.length + 3;

            int nextTagIndex = text.indexOf('[', i);
            String afterText = '';

            if (nextTagIndex != -1) {
              afterText = text.substring(i, nextTagIndex).trimLeft();
            }

            final combined =
                afterText.isNotEmpty ? '$headingText $afterText' : headingText;

            widgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: RichText(
                  text: TextSpan(
                    children: _parseInlineSpans(
                      combined,
                      baseStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            );

            if (afterText.isNotEmpty) {
              i = nextTagIndex;
            }
          }
        } else if (tag == 'list') {
          flush();
          pushText();

          final close = text.indexOf('[/list]', i);
          if (close != -1) {
            final content = text.substring(i, close);

            widgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _parseListItems(content, baseStyle),
                ),
              ),
            );

            i = close + 7;
          }
        } else if (tag == 'center') {
          flush();
          pushText();

          final close = text.indexOf('[/center]', i);
          if (close != -1) {
            final content = text.substring(i, close);

            widgets.add(
              Center(
                child: RichText(
                  text: TextSpan(
                    children: _parseInlineSpans(content, baseStyle),
                  ),
                ),
              ),
            );

            i = close + 9;
          }
        } else if (tag == 'p') {
          flush();
          pushText();
          widgets.add(const SizedBox(height: 1));
        } else {
          buffer.write('[$tag]');
        }
      } else {
        buffer.write(text[i++]);
      }
    }

    pushText();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        ...widgets,
      ],
    );
  }
}
