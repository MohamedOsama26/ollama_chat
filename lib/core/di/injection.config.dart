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
import 'package:ollama_chat/core/network/ollama_api_client.dart' as _i822;
import 'package:ollama_chat/features/chat/data/datasources/chat_local_datasource.dart'
    as _i1045;
import 'package:ollama_chat/features/chat/data/datasources/chat_local_datasource_impl.dart'
    as _i168;
import 'package:ollama_chat/features/chat/data/repositories/chat_repository_impl.dart'
    as _i242;
import 'package:ollama_chat/features/chat/domain/repositories/chat_repository.dart'
    as _i145;
import 'package:ollama_chat/features/chat/domain/usecases/chat_usecases.dart'
    as _i629;
import 'package:ollama_chat/features/chat/domain/usecases/send_message_use_case.dart'
    as _i934;
import 'package:ollama_chat/features/chat/presentation/bloc/chat_bloc.dart'
    as _i36;
import 'package:ollama_chat/features/models/data/repositories/model_repository_impl.dart'
    as _i124;
import 'package:ollama_chat/features/models/domain/repositories/model_repository.dart'
    as _i1060;
import 'package:ollama_chat/features/models/domain/usecases/list_models_use_case.dart'
    as _i622;
import 'package:ollama_chat/features/models/presentation/bloc/models_bloc.dart'
    as _i333;
import 'package:ollama_chat/features/sessions/data/datasources/session_local_datasource.dart'
    as _i775;
import 'package:ollama_chat/features/sessions/data/datasources/session_local_datasource_impl.dart'
    as _i78;
import 'package:ollama_chat/features/sessions/data/repositories/session_repository_impl.dart'
    as _i395;
import 'package:ollama_chat/features/sessions/domain/repositories/session_repository.dart'
    as _i907;
import 'package:ollama_chat/features/sessions/domain/usecases/session_usecases.dart'
    as _i488;
import 'package:ollama_chat/features/sessions/presentation/bloc/sessions_bloc.dart'
    as _i86;
import 'package:ollama_chat/features/settings/presentation/bloc/settings_bloc.dart'
    as _i587;
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
    gh.singleton<_i822.OllamaApiClient>(
        () => registerModule.ollamaApiClient(gh<_i460.SharedPreferences>()));
    gh.singleton<_i1060.ModelRepository>(
        () => _i124.ModelRepositoryImpl(gh<_i822.OllamaApiClient>()));
    gh.singleton<_i775.SessionLocalDatasource>(
        () => _i78.SessionLocalDatasourceImpl());
    gh.singleton<_i1045.ChatLocalDatasource>(
        () => _i168.ChatLocalDatasourceImpl());
    gh.singleton<_i587.SettingsBloc>(() => _i587.SettingsBloc(
          prefs: gh<_i460.SharedPreferences>(),
          apiClient: gh<_i822.OllamaApiClient>(),
        ));
    gh.singleton<_i145.ChatRepository>(() => _i242.ChatRepositoryImpl(
          gh<_i822.OllamaApiClient>(),
          gh<_i1045.ChatLocalDatasource>(),
        ));
    gh.factory<_i622.ListModelsUseCase>(
        () => _i622.ListModelsUseCase(gh<_i1060.ModelRepository>()));
    gh.singleton<_i907.SessionRepository>(
        () => _i395.SessionRepositoryImpl(gh<_i775.SessionLocalDatasource>()));
    gh.factory<_i333.ModelsBloc>(
        () => _i333.ModelsBloc(listModels: gh<_i622.ListModelsUseCase>()));
    gh.factory<_i934.SendMessageUseCase>(
        () => _i934.SendMessageUseCase(gh<_i145.ChatRepository>()));
    gh.factory<_i629.GetMessagesUseCase>(
        () => _i629.GetMessagesUseCase(gh<_i145.ChatRepository>()));
    gh.factory<_i629.SaveMessageUseCase>(
        () => _i629.SaveMessageUseCase(gh<_i145.ChatRepository>()));
    gh.factory<_i488.GetSessionsUseCase>(
        () => _i488.GetSessionsUseCase(gh<_i907.SessionRepository>()));
    gh.factory<_i488.CreateSessionUseCase>(
        () => _i488.CreateSessionUseCase(gh<_i907.SessionRepository>()));
    gh.factory<_i488.DeleteSessionUseCase>(
        () => _i488.DeleteSessionUseCase(gh<_i907.SessionRepository>()));
    gh.factory<_i86.SessionsBloc>(() => _i86.SessionsBloc(
          getSessions: gh<_i488.GetSessionsUseCase>(),
          createSession: gh<_i488.CreateSessionUseCase>(),
          deleteSession: gh<_i488.DeleteSessionUseCase>(),
        ));
    gh.factory<_i36.ChatBloc>(() => _i36.ChatBloc(
          sendMessage: gh<_i934.SendMessageUseCase>(),
          saveMessage: gh<_i629.SaveMessageUseCase>(),
          getMessages: gh<_i629.GetMessagesUseCase>(),
          updateSession: gh<_i907.SessionRepository>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i520.RegisterModule {}
