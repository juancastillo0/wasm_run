import 'package:flutter/material.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:flutter_example/state.dart';

class RustCryptoPage extends StatelessWidget {
  const RustCryptoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rustCryptoLoader = Inherited.get<GlobalState>(context).rustCrypto;
    final state = rustCryptoLoader.value;
    if (state == null) {
      return const CircularProgressIndicator();
    }
    return Column(
      children: [
        const Placeholder(),
      ],
    );
  }
}
