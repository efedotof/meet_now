// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:html' as html;

bool isHardReload() {
  try {
    final entries = html.window.performance.getEntriesByType('navigation');
    if (entries.isNotEmpty) {
      final navEntry = entries.first as dynamic;
      return navEntry.type == 'reload';
    }

    final nav = html.window.performance.navigation;
    return nav.type == 1;
  } catch (_) {}

  return false;
}
