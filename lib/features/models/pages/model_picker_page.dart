import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../bloc/models_bloc.dart';

class ModelPickerPage extends StatelessWidget {
  const ModelPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ModelsBloc>()..add(LoadModels()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Available models')),
        body: BlocBuilder<ModelsBloc, ModelsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text(state.error!),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () =>
                          context.read<ModelsBloc>().add(LoadModels()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.models.length,
              itemBuilder: (context, index) {
                final model = state.models[index];
                return ListTile(
                  leading: const Icon(Icons.memory),
                  title: Text(model.displayName),
                  subtitle: Text(model.sizeLabel),
                  trailing: const Icon(Icons.chevron_right),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
