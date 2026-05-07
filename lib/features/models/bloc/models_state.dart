part of 'models_bloc.dart';

class ModelsState extends Equatable {
  final List<OllamaModel> models;
  final bool isLoading;
  final String? error;

  const ModelsState({
    this.models = const [],
    this.isLoading = false,
    this.error,
  });

  ModelsState copyWith({
    List<OllamaModel>? models,
    bool? isLoading,
    String? error,
  }) =>
      ModelsState(
        models: models ?? this.models,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );

  @override
  List<Object?> get props => [models, isLoading, error];
}
