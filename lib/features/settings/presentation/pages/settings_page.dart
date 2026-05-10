import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../../../../core/di/injection.dart';
import 'package:ollama_chat/core/network/ollama_api_client.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _hostController;
  bool _testing = false;
  String? _testResult;

  @override
  void initState() {
    super.initState();
    final host = context.read<SettingsBloc>().state.ollamaHost;
    _hostController = TextEditingController(text: host);
  }

  Future<void> _testConnection() async {
    setState(() { _testing = true; _testResult = null; });
    final ok = await getIt<OllamaApiClient>().testConnection();
    setState(() {
      _testing = false;
      _testResult = ok ? 'Connected successfully!' : 'Could not connect to Ollama.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Ollama connection
              Text('Connection', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _hostController,
                decoration: const InputDecoration(
                  labelText: 'Ollama host URL',
                  hintText: 'http://localhost:11434',
                ),
                onSubmitted: (v) =>
                    context.read<SettingsBloc>().add(UpdateOllamaHost(v.trim())),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  FilledButton.tonal(
                    onPressed: _testing ? null : _testConnection,
                    child: _testing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Test connection'),
                  ),
                  if (_testResult != null) ...[
                    const SizedBox(width: 12),
                    Text(_testResult!,
                        style: TextStyle(
                          fontSize: 13,
                          color: _testResult!.contains('success')
                              ? Colors.green
                              : Theme.of(context).colorScheme.error,
                        )),
                  ],
                ],
              ),
              const Divider(height: 32),

              // Theme
              Text('Appearance', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto)),
                  ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
                ],
                selected: {state.themeMode},
                onSelectionChanged: (v) =>
                    context.read<SettingsBloc>().add(UpdateTheme(v.first)),
              ),
              const Divider(height: 32),

              // Language
              // TODO: Add full Arabic localization
              Text('Language', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<Locale>(
                segments: const [
                  ButtonSegment(value: Locale('en'), label: Text('English')),
                  ButtonSegment(value: Locale('ar'), label: Text('العربية')),
                ],
                selected: {state.locale},
                onSelectionChanged: (v) =>
                    context.read<SettingsBloc>().add(UpdateLocale(v.first)),
              ),
              const Divider(height: 32),

              // Web CORS note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.info_outline, size: 16,
                          color: Theme.of(context).colorScheme.onSecondaryContainer),
                      const SizedBox(width: 6),
                      Text('Web / browser mode',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSecondaryContainer)),
                    ]),
                    const SizedBox(height: 6),
                    Text(
                      'When running as a web app, start Ollama with CORS enabled:\n\nOLLAMA_ORIGINS=* ollama serve',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: Theme.of(context).colorScheme.onSecondaryContainer),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _hostController.dispose();
    super.dispose();
  }
}
