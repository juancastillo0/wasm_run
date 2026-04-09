// Simple Flutter app entry point for build testing
import 'package:flutter/material.dart';
import 'package:wasm_run/wasm_run.dart';

void main() {
  runApp(const WasmRunExampleApp());
}

class WasmRunExampleApp extends StatelessWidget {
  const WasmRunExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wasm Run Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('Wasm Run Example')),
        body: const Center(
          child: WasmRuntimeInfo(),
        ),
      ),
    );
  }
}

class WasmRuntimeInfo extends StatefulWidget {
  const WasmRuntimeInfo({super.key});

  @override
  State<WasmRuntimeInfo> createState() => _WasmRuntimeInfoState();
}

class _WasmRuntimeInfoState extends State<WasmRuntimeInfo> {
  String _info = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadRuntimeInfo();
  }

  Future<void> _loadRuntimeInfo() async {
    try {
      final features = await wasmRuntimeFeatures();
      setState(() {
        _info = 'Runtime: ${features.name} v${features.version}\n'
            'SIMD: ${features.supportedFeatures.simd}\n'
            'Threads: ${features.supportedFeatures.threads}';
      });
    } catch (e) {
      setState(() {
        _info = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_info, textAlign: TextAlign.center);
  }
}
