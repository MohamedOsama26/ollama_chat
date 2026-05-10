part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final String ollamaHost;
  final String defaultModel;
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsState({
    this.ollamaHost = 'http://localhost:11434',
    this.defaultModel = 'llama3',
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
  });

  SettingsState copyWith({
    String? ollamaHost,
    String? defaultModel,
    ThemeMode? themeMode,
    Locale? locale,
  }) =>
      SettingsState(
        ollamaHost: ollamaHost ?? this.ollamaHost,
        defaultModel: defaultModel ?? this.defaultModel,
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
      );

  @override
  List<Object?> get props => [ollamaHost, defaultModel, themeMode, locale];
}
