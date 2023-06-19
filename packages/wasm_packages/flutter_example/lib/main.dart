import 'package:flutter/material.dart';
import 'package:flutter_example/compression_rs_page.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:flutter_example/image_rs_page.dart';
import 'package:flutter_example/rust_crypto_page.dart';
import 'package:flutter_example/state.dart';
import 'package:flutter_example/wasm_parser_page.dart';
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
        appBarTheme: const AppBarTheme(
          toolbarHeight: 48,
        ),
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

enum AppTab {
  wasmParser,
  compressionRs,
  imageRs,
  rustCrypto;

  Widget tab(GlobalState state) {
    return switch (this) {
      AppTab.wasmParser => LoaderWidget(
          loader: state.wasmParser,
          child: const WasmParserPage(),
        ),
      AppTab.compressionRs => LoaderWidget(
          loader: state.compressionRs,
          child: const CompressionRsPage(),
        ),
      AppTab.imageRs => LoaderWidget(
          loader: state.imageRs,
          child: const ImageRsPage(),
        ),
      AppTab.rustCrypto => LoaderWidget(
          loader: state.rustCrypto,
          child: const RustCryptoPage(),
        ),
    };
  }
}

class _MyHomePageState extends State<MyHomePage> {
  late GlobalState state;
  AppTab tab = AppTab.wasmParser;

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
          title: Row(
            children: [
              Text(widget.title),
              const SizedBox(width: 10),
              if (MediaQuery.of(context).size.width > 1000)
                ...AppTab.values.map(
                  (t) => TextButton(
                    onPressed: () => setState(() {
                      tab = t;
                    }),
                    child: Text(t.name),
                  ),
                )
              else
                DropdownButtonFormField(
                  value: tab,
                  items: AppTab.values
                      .map((t) => DropdownMenuItem(
                            child: Text(t.name),
                          ))
                      .toList(),
                  onChanged: (t) => setState(() {
                    tab = t;
                  }),
                ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: tab.tab(state)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
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
