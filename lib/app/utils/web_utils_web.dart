// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

void updateWebBackground(bool isDark) {
  final color = isDark ? '#121212' : '#ffffff';

  html.document.body?.style.backgroundColor = color;
  html.document.documentElement?.style.backgroundColor = color;

  final meta = html.document.querySelector('meta[name="theme-color"]');
  if (meta != null) {
    meta.setAttribute('content', color);
  }
}
