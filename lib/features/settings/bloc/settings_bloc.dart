import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/errors/app_constants.dart';
import '../../../data/datasources/ollama_api_client.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@singleton
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences prefs;
  final OllamaApiClient apiClient;

  SettingsBloc({required this.prefs, required this.apiClient})
      : super(const SettingsState()) {
    on<LoadSettings>(_onLoad);
    on<UpdateOllamaHost>(_onUpdateHost);
    on<UpdateTheme>(_onUpdateTheme);
    on<UpdateDefaultModel>(_onUpdateModel);
    on<UpdateLocale>(_onUpdateLocale);
  }

  void _onLoad(LoadSettings event, Emitter<SettingsState> emit) {
    emit(state.copyWith(
      ollamaHost: prefs.getString(AppConstants.keyOllamaHost) ??
          AppConstants.defaultOllamaHost,
      defaultModel:
          prefs.getString(AppConstants.keyDefaultModel) ?? AppConstants.defaultModel,
      themeMode: ThemeMode.values[prefs.getInt(AppConstants.keyThemeMode) ?? 0],
      locale: Locale(prefs.getString(AppConstants.keyLocale) ?? 'en'),
    ));
  }

  Future<void> _onUpdateHost(
      UpdateOllamaHost event, Emitter<SettingsState> emit) async {
    await prefs.setString(AppConstants.keyOllamaHost, event.host);
    apiClient.updateBaseUrl(event.host);
    emit(state.copyWith(ollamaHost: event.host));
  }

  Future<void> _onUpdateTheme(
      UpdateTheme event, Emitter<SettingsState> emit) async {
    await prefs.setInt(AppConstants.keyThemeMode, event.themeMode.index);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  Future<void> _onUpdateModel(
      UpdateDefaultModel event, Emitter<SettingsState> emit) async {
    await prefs.setString(AppConstants.keyDefaultModel, event.model);
    emit(state.copyWith(defaultModel: event.model));
  }

  Future<void> _onUpdateLocale(
      UpdateLocale event, Emitter<SettingsState> emit) async {
    await prefs.setString(AppConstants.keyLocale, event.locale.languageCode);
    emit(state.copyWith(locale: event.locale));
  }
}
