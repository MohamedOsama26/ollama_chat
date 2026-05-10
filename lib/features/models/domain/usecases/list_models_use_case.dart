import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';
import 'package:ollama_chat/core/errors/failures.dart';
import '../repositories/model_repository.dart';

@injectable
class ListModelsUseCase {
  final ModelRepository repository;
  ListModelsUseCase(this.repository);

  Future<Either<Failure, List<OllamaModel>>> call() => repository.getModels();
}
