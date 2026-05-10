import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/ollama_api_client.dart';
import '../errors/app_constants.dart';

@module
abstract class RegisterModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  OllamaApiClient ollamaApiClient(SharedPreferences prefs) => OllamaApiClient(
        baseUrl: prefs.getString(AppConstants.keyOllamaHost),
      );
}
