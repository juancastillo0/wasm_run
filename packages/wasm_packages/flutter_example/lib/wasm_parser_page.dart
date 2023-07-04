import 'dart:convert';

import 'package:file_system_access/file_system_access.dart' as fsa;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:flutter_example/paginated_text.dart';
import 'package:flutter_example/state.dart';
import 'package:flutter_example/wasm_parser_state.dart';
import 'package:wasm_parser/wasm_parser.dart';

class WasmParserPage extends StatelessWidget {
  const WasmParserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wasmParserLoader = Inherited.get<GlobalState>(context).wasmParser;
    final state = wasmParserLoader.value;
    if (state == null) {
      return const CircularProgressIndicator();
    }
    final isSmall = MediaQuery.of(context).size.width < 1000;
    final isVerySmall = MediaQuery.of(context).size.width < 660;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        if (isVerySmall) {
          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      WatView(state: state),
                      WasmTypeView(state: state),
                      WasmComponentView(state: state),
                    ],
                  ),
                ),
                const TabBar(
                  tabs: [
                    Tab(child: Text('WAT')),
                    Tab(child: Text('WASM')),
                    Tab(child: Text('WIT')),
                  ],
                ),
              ],
            ),
          );
        }
        if (isSmall) {
          return DefaultTabController(
            length: 2,
            child: Row(
              children: [
                Expanded(child: WasmTypeView(state: state)),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          children: [
                            WatView(state: state),
                            WasmComponentView(state: state)
                          ],
                        ),
                      ),
                      const TabBar(
                        tabs: [
                          Tab(child: Text('WAT')),
                          Tab(child: Text('WIT')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Row(
          children: [
            Expanded(child: WatView(state: state)),
            Expanded(child: WasmTypeView(state: state)),
            Expanded(child: WasmComponentView(state: state)),
          ],
        ).container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
        );
      },
    );
  }
}

const wasmFileType = fsa.FilePickerAcceptType(
  description: 'WebAssembly',
  accept: {
    'application/wasm': ['.wasm']
  },
);
const watFileType = fsa.FilePickerAcceptType(
  description: 'WebAssemblyText',
  accept: {
    'application/wat': ['.wat']
  },
);

void loadWasm(void Function(String name, Uint8List bytes) onLoad) async {
  final files = await fsa.FileSystem.instance.showOpenFilePickerWebSafe(
    const fsa.FsOpenOptions(
      multiple: false,
      types: [wasmFileType],
    ),
  );
  if (files.isNotEmpty) {
    final file = files.first;
    final bytes = await file.file.readAsBytes();
    onLoad(file.file.name, bytes);
  }
}

class WatView extends StatelessWidget {
  const WatView({
    super.key,
    required this.state,
  });

  final WasmParserState state;

  @override
  Widget build(BuildContext context) {
    void loadWat() async {
      final files = await fsa.FileSystem.instance.showOpenFilePickerWebSafe(
        const fsa.FsOpenOptions(
          multiple: false,
          types: [watFileType],
        ),
      );
      if (files.isNotEmpty) {
        final file = files.first;
        final text = await file.file.readAsString();
        state.setWat(text);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text('WAT').title(),
            ElevatedButton(
              onPressed: loadWat,
              child: const Text('load'),
            ),
            ElevatedButton(
              onPressed: () => downloadFile(
                'module.wat',
                const Utf8Encoder().convert(state.watController.joinedText),
                types: [watFileType],
              ),
              child: const Text('download'),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Examples:')
                    .container(padding: const EdgeInsets.only(left: 10)),
                ButtonBar(
                  buttonPadding: const EdgeInsets.all(1),
                  children: [
                    ...WatExample.values.map(
                      (e) => TextButton(
                        onPressed: () {
                          state.setWat(e.wat);
                        },
                        child: Text(e.name),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: PaginatedTextField(
            controller: state.watController,
          ),
        ),
      ],
    );
  }
}

class WasmTypeView extends StatelessWidget {
  const WasmTypeView({
    super.key,
    required this.state,
  });

  final WasmParserState state;

  @override
  Widget build(BuildContext context) {
    void downloadWasm() async {
      final moduleBytes = state.wat2wasm();
      if (moduleBytes == null) return;
      await downloadFile('module.wasm', moduleBytes, types: [wasmFileType]);
    }

    Widget wasmModuleTypeWidget(ModuleType value) {
      final line = BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      );
      const externNameStyle = TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('ModuleType')
                .title()
                .container(alignment: Alignment.center),
            const Text('Imports').subtitle(),
            if (value.imports.isEmpty)
              const Text('No imports')
                  .container(padding: const EdgeInsets.all(6)),
            ...value.imports.map(
              (e) => SelectableText.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${e.module}.${e.name}',
                      style: externNameStyle,
                    ),
                    TextSpan(text: '\n${e.type}'),
                  ],
                ),
              ).container(
                padding: const EdgeInsets.all(6),
                decoration: line,
              ),
            ),
            const Text('Exports').subtitle(),
            if (value.exports.isEmpty) const Text('No exports'),
            ...value.exports.map(
              (e) => SelectableText.rich(
                TextSpan(
                  children: [
                    TextSpan(text: e.name, style: externNameStyle),
                    TextSpan(text: '\n${e.type}'),
                  ],
                ),
              ).container(
                padding: const EdgeInsets.all(6),
                decoration: line,
              ),
            )
          ],
        ).container(padding: const EdgeInsets.all(6)),
      );
    }

    Widget wasmTypeWidget() {
      if (state.wasmType == null) {
        return const Text(
          'No WASM file parsed.\nLoad a binary file, parse the WAT text with "wat2wasm" or select an example WAT',
          textAlign: TextAlign.center,
        ).container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(20),
        );
      }
      return Column(
        children: [
          switch (state.wasmType!) {
            final ModuleType value => wasmModuleTypeWidget(value),
            final ComponentType value => Column(
                children: [
                  const Text('ComponentType').title(),
                  const Text('Modules'),
                  ...value.modules.map(wasmModuleTypeWidget)
                ],
              ),
          },
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text('WASM').title(),
            ElevatedButton(
              onPressed: () => loadWasm(
                (_, bytes) => state.loadWasm(bytes),
              ),
              child: const Text('load'),
            ),
            if (state.wasmType != null)
              ElevatedButton(
                onPressed: downloadWasm,
                child: const Text('download'),
              ),
            ElevatedButton(
              onPressed: state.wat2wasm,
              child: const Text('wat2wasm'),
            ),
            DropdownButtonFormField(
              isDense: true,
              isExpanded: true,
              items: [
                'packages/wasm_parser/lib/assets/wasm_parser_wasm.wasm',
                'packages/wasm_parser/lib/assets/wasm_parser_wasm.threads.wasm',
                'packages/compression_rs/lib/assets/compression_rs_wasm.wasm',
                'packages/compression_rs/lib/assets/compression_rs_wasm.threads.wasm',
                'packages/rust_crypto/lib/assets/rust_crypto_wasm.wasm',
                'packages/image_rs/lib/assets/image_rs_wasm.wasm',
              ]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        Uri.parse(e)
                            .pathSegments
                            .last
                            .replaceFirst(RegExp(r'.wasm$'), ''),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                  .toList(),
              value: null,
              hint: const Text('Packages'),
              onChanged: (v) async {
                if (v == null) return;
                final bytes = await rootBundle.load(v);
                state.loadWasm(bytes.buffer.asUint8List());
              },
            ).container(
              width: 200,
              padding: const EdgeInsets.only(left: 10),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(child: wasmTypeWidget()),
        ),
        ErrorMessage(state: state),
      ],
    );
  }
}

class WasmComponentView extends StatelessWidget {
  const WasmComponentView({
    super.key,
    required this.state,
  });

  final WasmParserState state;

  @override
  Widget build(BuildContext context) {
    void createComponent() async {
      final componentBytes = state.wasm2component();
      if (componentBytes == null) return;
      await downloadFile(
        'component.wasm',
        componentBytes,
        types: [wasmFileType],
      );
    }

    void addAdapter() {
      loadWasm(
        (name, bytes) async {
          String name_ = name.split('.').first;
          await showDialog<Object?>(
            context: context,
            builder: (context) {
              final navigator = Navigator.of(context);
              return AlertDialog(
                content: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Adapter Name',
                  ),
                  initialValue: name_,
                  onFieldSubmitted: (name) {
                    name_ = name;
                    navigator.pop();
                  },
                  onChanged: (name) => name_ = name,
                ),
                actions: [
                  TextButton(
                    onPressed: navigator.pop,
                    child: const Text('Accept'),
                  ),
                ],
              );
            },
          );

          state.addAdapter(
            ComponentAdapter(
              name: name_,
              wasm: WasmInput.binary(bytes),
            ),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text('Wasm Component').title(),
            ElevatedButton(
              onPressed: createComponent,
              child: const Text('createComponent'),
            ),
            // TODO: wasi adapter
            ElevatedButton(
              onPressed: addAdapter,
              child: const Text('addAdapter'),
            ),
          ],
        ),
        if (state.adapters.isEmpty)
          const Text('No Adapters').container(
            padding: const EdgeInsets.all(18),
            alignment: Alignment.center,
          )
        else
          Column(
            children: [
              ...state.adapters.values.map(
                (e) => Row(
                  key: Key(e.name),
                  children: [
                    const SizedBox(width: 10),
                    Text(e.name).container(padding: const EdgeInsets.all(6)),
                    if (e.wasm is WasmInputBinary)
                      TextButton(
                        onPressed: () => state.loadWasm(
                          (e.wasm as WasmInputBinary).value,
                        ),
                        child: const Text('loadWasm'),
                      ),
                    IconButton(
                      onPressed: () => state.removeAdapter(e.name),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
            ],
          ),
        Row(
          children: [
            const Text('WIT').title(),
            ElevatedButton(
              onPressed: state.wasm2wit,
              child: const Text('wasm2wit'),
            ),
          ],
        ),
        Expanded(
          child: TextField(
            controller: state.witController,
            maxLines: 1000,
            style: codeTextStyle,
          ),
        ),
      ],
    );
  }
}
