import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';
import 'package:ollama_chat/core/errors/failures.dart';
import 'package:ollama_chat/core/network/ollama_api_client.dart';
import '../../domain/repositories/model_repository.dart';

@Singleton(as: ModelRepository)
class ModelRepositoryImpl implements ModelRepository {
  final OllamaApiClient apiClient;
  ModelRepositoryImpl(this.apiClient);

  @override
  Future<Either<Failure, List<OllamaModel>>> getModels() async {
    try {
      return Right(await apiClient.getModels());
    } on Exception catch (_) {
      return const Left(OllamaUnreachableFailure());
    }
  }
}
