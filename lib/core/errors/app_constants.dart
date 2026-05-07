class AppConstants {
  // Ollama API
  static const String defaultOllamaHost = 'http://localhost:11434';
  static const String defaultModel = 'llama3';
  static const String apiChat = '/api/chat';
  static const String apiTags = '/api/tags';

  // Hive boxes
  static const String sessionsBox = 'sessions';
  static const String messagesBox = 'messages';

  // SharedPreferences keys
  static const String keyOllamaHost = 'ollama_host';
  static const String keyDefaultModel = 'default_model';
  static const String keyThemeMode = 'theme_mode';
  static const String keyFontSize = 'font_size';
  static const String keyLocale = 'locale';

  // Egyptian Arabic system prompt
  // TODO: Allow user to customize this in settings
  static const String egyptianArabicSystemPrompt =
      'أنت مساعد ذكي بتتكلم بالعامية المصرية. رد دايمًا بالعربي المصري الواضح والمفهوم.';

  // UI
  static const double sidebarWidth = 280.0;
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
}
