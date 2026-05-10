import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';
import '../../domain/usecases/list_models_use_case.dart';

part 'models_event.dart';
part 'models_state.dart';

@injectable
class ModelsBloc extends Bloc<ModelsEvent, ModelsState> {
  final ListModelsUseCase listModels;
  ModelsBloc({required this.listModels}) : super(const ModelsState()) {
    on<LoadModels>(_onLoad);
  }

  Future<void> _onLoad(LoadModels event, Emitter<ModelsState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await listModels();
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (models) => emit(state.copyWith(isLoading: false, models: models)),
    );
  }
}
