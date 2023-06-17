import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:flutter_example/state.dart';
import 'package:flutter_example/wasm_parser_state.dart';
import 'package:wasm_parser/wasm_parser.dart';
import 'package:file_system_access/file_system_access.dart' as fsa;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wasm Run Packages',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          filled: true,
          labelStyle: TextStyle(height: 0.5),
          // isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          // enabledBorder: UnderlineInputBorder(
          //   // borderSide: BorderSide(
          //   //   color: Colors.black12,
          //   // ),
          // ),
        ),
      ),
      home: const MyHomePage(title: 'Wasm Run Packages'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GlobalState state;

  @override
  void initState() {
    super.initState();
    state = GlobalState();
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Inherited(
      state: state,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            TextButton(
              onPressed: () => launchUrl(
                Uri.parse('https://github.com/juancastillo0/wasm_run'),
              ),
              child: const Text('GitHub'),
            ),
            const SizedBox(width: 10),
          ],
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: LoaderWidget(
                  loader: state.wasmParser,
                  child: const WasmParserPage(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageRsPage extends StatelessWidget {
  const ImageRsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Inherited.get<GlobalState>(context).imageRs;
    return const Placeholder();
  }
}

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key, required this.loader, required this.child});

  final FutureLoader loader;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: loader,
      builder: (context, _) {
        final state = loader.value;
        if (loader.error.isNotEmpty) {
          return Column(
            children: [
              Text(loader.error).container(padding: const EdgeInsets.all(12)),
              ElevatedButton(
                onPressed: loader.load,
                child: const Text('Retry'),
              ),
            ],
          );
        } else if (state == null) {
          loader.load();
          return const CircularProgressIndicator()
              .container(alignment: Alignment.center);
        }
        return child;
      },
    );
  }
}

class WasmParserPage extends StatelessWidget {
  const WasmParserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wasmParserLoader = Inherited.get<GlobalState>(context).wasmParser;
    final state = wasmParserLoader.value;
    if (state == null) {
      return const CircularProgressIndicator();
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

    Future<void> downloadFile(String name, Uint8List bytes) async {
      if (!fsa.FileSystem.instance.isSupported) {
        await fsa.XFile.fromData(bytes).saveTo(name);
      } else {
        final handle = await fsa.FileSystem.instance.showSaveFilePicker(
          fsa.FsSaveOptions(types: const [wasmFileType], suggestedName: name),
        );
        if (handle == null) return;
        final writable = await handle.createWritable(keepExistingData: false);
        await writable.write(
          fsa.FileSystemWriteChunkType.bufferSource(
            bytes.buffer,
          ),
        );
        await writable.close();
      }
    }

    void createComponent() async {
      final componentBytes = state.wasm2component();
      if (componentBytes == null) return;
      await downloadFile('component.wasm', componentBytes);
    }

    void downloadWasm() async {
      final moduleBytes = state.wat2wasm();
      if (moduleBytes == null) return;
      await downloadFile('module.wasm', moduleBytes);
    }

    Widget wasmModuleTypeWidget(ModuleType value) {
      final line = BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
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
              (e) => Text('${e.module}.${e.name}\n${e.type}').container(
                padding: const EdgeInsets.all(6),
                decoration: line,
              ),
            ),
            const Text('Exports').subtitle(),
            if (value.exports.isEmpty) const Text('No exports'),
            ...value.exports.map(
              (e) => Text('${e.name}\n${e.type}').container(
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
        ).container(padding: const EdgeInsets.all(20));
      }
      return Column(
        children: [
          switch (state.wasmType!) {
            WasmTypeModuleType(:final value) => wasmModuleTypeWidget(value),
            WasmTypeComponentType(:final value) => Column(
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

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('WAT').title(),
                      ElevatedButton(
                        onPressed: loadWat,
                        child: const Text('loadWat'),
                      ),
                      Row(
                        children: [
                          const Text('Examples:').container(
                              padding: const EdgeInsets.only(left: 10)),
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
                    child: TextField(
                      controller: state.watController,
                      maxLines: 1000,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('WASM').title(),
                      ElevatedButton(
                        onPressed: () => loadWasm(
                          (_, bytes) => state.loadWasm(bytes),
                        ),
                        child: const Text('loadWasm'),
                      ),
                      if (state.wasmType != null)
                        ElevatedButton(
                          onPressed: downloadWasm,
                          child: const Text('downloadWasm'),
                        ),
                      ElevatedButton(
                        onPressed: state.wat2wasm,
                        child: const Text('wat2wasm'),
                      )
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(child: wasmTypeWidget()),
                  ),
                  if (state.error.isNotEmpty)
                    Row(
                      children: [
                        Expanded(child: Text(state.error)),
                        ElevatedButton(
                          onPressed: () => state.setError(''),
                          child: const Text('Close'),
                        )
                      ],
                    ).container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(12),
                      color: Colors.red.shade100,
                    ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Wasm Component').title(),
                      ElevatedButton(
                        onPressed: createComponent,
                        child: const Text('createComponent'),
                      ),
                      // TODO: wasi adapter
                      ElevatedButton(
                        onPressed: () {
                          loadWasm(
                            (name, bytes) async {
                              String name_ = name.split('.').first;
                              await showDialog(
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
                        },
                        child: const Text('addAdapter'),
                      ),
                    ],
                  ),
                  if (state.adapters.isEmpty)
                    const Text('No Adapters')
                  else
                    Column(
                      children: [
                        ...state.adapters.values.map(
                          (e) => Row(
                            key: Key(e.name),
                            children: [
                              const SizedBox(width: 10),
                              Text(e.name)
                                  .container(padding: const EdgeInsets.all(6)),
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
        );
      },
    );
  }
}

extension TextExt on Text {
  Widget title() => Text(
        data!,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ).container(padding: const EdgeInsets.all(12));

  Widget subtitle() => Text(
        data!,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ).container(padding: const EdgeInsets.all(4));
}

extension ContainerExt on Widget {
  Widget container({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
  }) {
    return Container(
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: this,
    );
  }
}
