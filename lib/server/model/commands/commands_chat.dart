enum CommandsChat {
  icebRandom('/iceb_random'),
  icebSearch('/iceb_search'),
  games('/games'),
  icebGetAll('/iceb_getall');

  final String command;
  const CommandsChat(this.command);

  static CommandsChat? fromString(String text) {
    final normalizedText = text.toLowerCase().trim();
    for (final value in values) {
      if (value.command == normalizedText) return value;
    }
    return null;
  }
}
