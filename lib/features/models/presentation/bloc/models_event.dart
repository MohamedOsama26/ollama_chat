part of 'models_bloc.dart';

abstract class ModelsEvent extends Equatable {
  const ModelsEvent();
  @override
  List<Object?> get props => [];
}

class LoadModels extends ModelsEvent {}
