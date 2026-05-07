part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateOllamaHost extends SettingsEvent {
  final String host;
  const UpdateOllamaHost(this.host);
  @override
  List<Object?> get props => [host];
}

class UpdateTheme extends SettingsEvent {
  final ThemeMode themeMode;
  const UpdateTheme(this.themeMode);
  @override
  List<Object?> get props => [themeMode];
}

class UpdateDefaultModel extends SettingsEvent {
  final String model;
  const UpdateDefaultModel(this.model);
  @override
  List<Object?> get props => [model];
}

class UpdateLocale extends SettingsEvent {
  final Locale locale;
  const UpdateLocale(this.locale);
  @override
  List<Object?> get props => [locale];
}
