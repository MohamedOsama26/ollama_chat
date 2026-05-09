// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:ollama_chat/core/di/register_module.dart' as _i520;
import 'package:ollama_chat/data/datasources/local_datasource.dart' as _i729;
import 'package:ollama_chat/data/datasources/ollama_api_client.dart' as _i776;
import 'package:ollama_chat/data/repositories/repository_impl.dart' as _i450;
import 'package:ollama_chat/domain/repositories/repositories.dart' as _i330;
import 'package:ollama_chat/domain/usecases/usecases.dart' as _i745;
import 'package:ollama_chat/features/chat/bloc/chat_bloc.dart' as _i850;
import 'package:ollama_chat/features/models/bloc/models_bloc.dart' as _i708;
import 'package:ollama_chat/features/sessions/bloc/sessions_bloc.dart' as _i73;
import 'package:ollama_chat/features/settings/bloc/settings_bloc.dart' as _i210;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    await gh.singletonAsync<_i729.LocalDatasource>(
      () => registerModule.localDatasource(),
      preResolve: true,
    );
    gh.singleton<_i776.OllamaApiClient>(
        () => registerModule.ollamaApiClient(gh<_i460.SharedPreferences>()));
    gh.singleton<_i210.SettingsBloc>(() => _i210.SettingsBloc(
          prefs: gh<_i460.SharedPreferences>(),
          apiClient: gh<_i776.OllamaApiClient>(),
        ));
    gh.singleton<_i330.SessionRepository>(
        () => _i450.SessionRepositoryImpl(gh<_i729.LocalDatasource>()));
    gh.singleton<_i330.ChatRepository>(
        () => _i450.ChatRepositoryImpl(gh<_i776.OllamaApiClient>()));
    gh.singleton<_i330.ModelRepository>(
        () => _i450.ModelRepositoryImpl(gh<_i776.OllamaApiClient>()));
    gh.factory<_i745.SendMessageUseCase>(
        () => _i745.SendMessageUseCase(gh<_i330.ChatRepository>()));
    gh.factory<_i745.ListModelsUseCase>(
        () => _i745.ListModelsUseCase(gh<_i330.ModelRepository>()));
    gh.factory<_i745.GetSessionsUseCase>(
        () => _i745.GetSessionsUseCase(gh<_i330.SessionRepository>()));
    gh.factory<_i745.CreateSessionUseCase>(
        () => _i745.CreateSessionUseCase(gh<_i330.SessionRepository>()));
    gh.factory<_i745.DeleteSessionUseCase>(
        () => _i745.DeleteSessionUseCase(gh<_i330.SessionRepository>()));
    gh.factory<_i745.GetMessagesUseCase>(
        () => _i745.GetMessagesUseCase(gh<_i330.SessionRepository>()));
    gh.factory<_i745.SaveMessageUseCase>(
        () => _i745.SaveMessageUseCase(gh<_i330.SessionRepository>()));
    gh.factory<_i73.SessionsBloc>(() => _i73.SessionsBloc(
          getSessions: gh<_i745.GetSessionsUseCase>(),
          createSession: gh<_i745.CreateSessionUseCase>(),
          deleteSession: gh<_i745.DeleteSessionUseCase>(),
        ));
    gh.factory<_i850.ChatBloc>(() => _i850.ChatBloc(
          sendMessage: gh<_i745.SendMessageUseCase>(),
          saveMessage: gh<_i745.SaveMessageUseCase>(),
          getMessages: gh<_i745.GetMessagesUseCase>(),
          updateSession: gh<_i330.SessionRepository>(),
        ));
    gh.factory<_i708.ModelsBloc>(
        () => _i708.ModelsBloc(listModels: gh<_i745.ListModelsUseCase>()));
    return this;
  }
}

class _$RegisterModule extends _i520.RegisterModule {}
