abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class OllamaUnreachableFailure extends Failure {
  const OllamaUnreachableFailure()
      : super('Cannot connect to Ollama. Make sure Ollama is running.');
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
