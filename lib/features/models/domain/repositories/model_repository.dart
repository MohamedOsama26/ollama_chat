import 'package:dartz/dartz.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';
import 'package:ollama_chat/core/errors/failures.dart';

abstract class ModelRepository {
  Future<Either<Failure, List<OllamaModel>>> getModels();
}
