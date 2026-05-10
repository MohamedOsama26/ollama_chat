import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';
import 'package:ollama_chat/core/errors/failures.dart';
import '../datasources/session_local_datasource.dart';
import '../../domain/repositories/session_repository.dart';

@Singleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  final SessionLocalDatasource localDatasource;
  SessionRepositoryImpl(this.localDatasource);

  @override
  Future<Either<Failure, List<ChatSession>>> getSessions() async {
    try {
      return Right(await localDatasource.getSessions());
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatSession>> createSession(ChatSession session) async {
    try {
      await localDatasource.saveSession(session);
      return Right(session);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSession(ChatSession session) async {
    try {
      await localDatasource.saveSession(session);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSession(String sessionId) async {
    try {
      await localDatasource.deleteSession(sessionId);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }
}
