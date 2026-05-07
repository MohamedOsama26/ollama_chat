import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local_datasource.dart';
import '../../data/datasources/ollama_api_client.dart';
import '../../data/repositories/repository_impl.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/usecases.dart';
import '../../features/chat/bloc/chat_bloc.dart';
import '../../features/sessions/bloc/sessions_bloc.dart';
import '../../features/models/bloc/models_bloc.dart';
import '../../features/settings/bloc/settings_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Datasources
  final localDs = LocalDatasource();
  await localDs.init();
  getIt.registerSingleton<LocalDatasource>(localDs);

  final host = prefs.getString('ollama_host') ?? 'http://localhost:11434';
  getIt.registerSingleton<OllamaApiClient>(OllamaApiClient(baseUrl: host));

  // Repositories
  getIt.registerSingleton<ChatRepository>(
      ChatRepositoryImpl(getIt<OllamaApiClient>()));
  getIt.registerSingleton<SessionRepository>(
      SessionRepositoryImpl(getIt<LocalDatasource>()));
  getIt.registerSingleton<ModelRepository>(
      ModelRepositoryImpl(getIt<OllamaApiClient>()));

  // Use cases
  getIt.registerFactory(() => SendMessageUseCase(getIt<ChatRepository>()));
  getIt.registerFactory(() => GetSessionsUseCase(getIt<SessionRepository>()));
  getIt.registerFactory(() => CreateSessionUseCase(getIt<SessionRepository>()));
  getIt.registerFactory(() => DeleteSessionUseCase(getIt<SessionRepository>()));
  getIt.registerFactory(() => GetMessagesUseCase(getIt<SessionRepository>()));
  getIt.registerFactory(() => SaveMessageUseCase(getIt<SessionRepository>()));
  getIt.registerFactory(() => ListModelsUseCase(getIt<ModelRepository>()));

  // Blocs
  getIt.registerFactory(() => ChatBloc(
        sendMessage: getIt<SendMessageUseCase>(),
        saveMessage: getIt<SaveMessageUseCase>(),
        getMessages: getIt<GetMessagesUseCase>(),
        updateSession: SessionRepositoryImpl(getIt<LocalDatasource>()),
      ));
  getIt.registerFactory(() => SessionsBloc(
        getSessions: getIt<GetSessionsUseCase>(),
        createSession: getIt<CreateSessionUseCase>(),
        deleteSession: getIt<DeleteSessionUseCase>(),
      ));
  getIt.registerFactory(() => ModelsBloc(
        listModels: getIt<ListModelsUseCase>(),
      ));
  getIt.registerSingleton<SettingsBloc>(SettingsBloc(
    prefs: getIt<SharedPreferences>(),
    apiClient: getIt<OllamaApiClient>(),
  ));
}
