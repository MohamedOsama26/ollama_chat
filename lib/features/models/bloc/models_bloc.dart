import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

part 'models_event.dart';
part 'models_state.dart';

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
