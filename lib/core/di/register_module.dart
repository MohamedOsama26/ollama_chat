import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local_datasource.dart';
import '../../data/datasources/ollama_api_client.dart';
import '../errors/app_constants.dart';

@module
abstract class RegisterModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  @singleton
  Future<LocalDatasource> localDatasource() async {
    final ds = LocalDatasource();
    await ds.init();
    return ds;
  }

  @singleton
  OllamaApiClient ollamaApiClient(SharedPreferences prefs) => OllamaApiClient(
        baseUrl: prefs.getString(AppConstants.keyOllamaHost),
      );
}
