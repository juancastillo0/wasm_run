import 'package:flutter/material.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:flutter_example/state.dart';

class CompressionRsPage extends StatelessWidget {
  const CompressionRsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wasmParserLoader = Inherited.get<GlobalState>(context).wasmParser;
    final state = wasmParserLoader.value;
    if (state == null) {
      return const CircularProgressIndicator();
    }
    return const Placeholder();
  }
}
