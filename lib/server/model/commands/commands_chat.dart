enum CommandsChat {
  iceb,
  chatgame;

  String get command => '/$name';

  static CommandsChat? fromString(String text) {
    final command = text.startsWith('/') ? text.substring(1) : text;
    for (final value in values) {
      if (value.name == command) return value;
    }
    return null;
  }
}
