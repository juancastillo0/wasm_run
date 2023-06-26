import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:flutter_example/rust_crypto_state.dart';
import 'package:flutter_example/state.dart';
import 'package:rust_crypto/rust_crypto.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

class RustCryptoPage extends StatelessWidget {
  const RustCryptoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rustCryptoLoader = Inherited.get<GlobalState>(context).rustCrypto;
    final state = rustCryptoLoader.value;
    if (state == null) {
      return const CircularProgressIndicator();
    }
    final isVerySmall = MediaQuery.of(context).size.width < 800;
    final isSmall = MediaQuery.of(context).size.width < 1250;
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
                      SingleChildScrollView(
                        child: HashAndHmacView(state: state),
                      ),
                      SingleChildScrollView(child: Aes256GcmView(state: state)),
                      SingleChildScrollView(
                        child: Argon2PasswordView(state: state),
                      ),
                    ],
                  ),
                ),
                const TabBar(
                  tabs: [
                    Tab(child: Text('HASH & MAC')),
                    Tab(child: Text('AES GCM SIV')),
                    Tab(child: Text('ARGON2')),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Aes256GcmView(state: state),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: HashAndHmacView(state: state),
                            ),
                            SingleChildScrollView(
                              child: Argon2PasswordView(state: state),
                            ),
                          ],
                        ),
                      ),
                      const TabBar(
                        tabs: [
                          Tab(child: Text('HASH & MAC')),
                          Tab(child: Text('ARGON2')),
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: HashAndHmacView(state: state),
            ),
            const SizedBox(width: 20),
            SingleChildScrollView(
              child: Aes256GcmView(state: state),
            ),
            const SizedBox(width: 20),
            SingleChildScrollView(
              child: Argon2PasswordView(state: state),
            ),
          ],
        );
      },
    );
  }
}

class HashAndHmacView extends StatelessWidget {
  const HashAndHmacView({
    super.key,
    required this.state,
  });

  final RustCryptoState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('HASH and HMAC').title(),
        const SizedBox(height: 8),
        BinaryInputWidget(data: state.hashInput, label: 'Hash Input'),
        BinaryInputWidget(
          data: state.hmacKeyInput,
          label: 'Hmac Key (512bit/64Byte)',
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BinaryDataEncodingButtons(
              data: BinaryInputData(
                () => state.hashOutputEncodingSet(
                  state.hashOutputEncoding == InputEncoding.hex
                      ? InputEncoding.base64
                      : InputEncoding.hex,
                ),
                isKey: true,
              )..encoding = state.hashOutputEncoding,
            ),
            ElevatedButton(
              onPressed: state.computeHashValues,
              child: const Text('Compute'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Algorithm').container(width: 70),
            const Expanded(child: Text('Hash', textAlign: TextAlign.center)),
            const Expanded(child: Text('Hmac', textAlign: TextAlign.center)),
          ],
        ),
        Column(
          children: [
            ...RCHash.values.map(
              (e) => Row(
                children: [
                  SelectableText(e.name).container(width: 70),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            state.hashValues[e] ?? '',
                            style: const TextStyle(
                              overflow: TextOverflow.clip,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        copyButton(state.hashValues[e] ?? ''),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            state.hmacValues[e] ?? '',
                            style: const TextStyle(
                              overflow: TextOverflow.fade,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        copyButton(state.hashValues[e] ?? ''),
                      ],
                    ),
                  ),
                ],
              ).container(
                padding: const EdgeInsets.all(4),
                height: 60,
                // width: 300,
              ),
            ),
          ],
        ),
      ],
    ).container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      constraints: const BoxConstraints(maxWidth: 400),
    );
  }
}

class Aes256GcmView extends StatelessWidget {
  const Aes256GcmView({
    super.key,
    required this.state,
  });

  final RustCryptoState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('AES 256 GCM SIV').title(),
        const SizedBox(height: 8),
        BinaryInputWidget(
          data: state.aesKeyInput,
          label: 'Aes Key (256bit/32Byte)',
        ),
        TextField(
          controller: state.nonceController,
          decoration: InputDecoration(
            labelText: 'Nonce (base64 - 96bit/12Byte)',
            suffixIcon: IconButton(
              onPressed: state.generateNonce,
              icon: const Icon(Icons.refresh),
            ),
          ),
        ),
        TextField(
          controller: state.associatedDataController,
          decoration: const InputDecoration(
            labelText: 'Associated Data (UTF-8)',
          ),
        ),
        BinaryInputWidget(
          data: state.planTextInput,
          label: 'Plain Text',
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Nonce Concatenation'),
            const SizedBox(width: 4),
            Checkbox(
              onChanged: (_) => state.isConcatToggle(),
              value: state.isConcat,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: state.encrypt,
              icon: const Icon(Icons.arrow_downward_rounded),
              label: const Text('Encrypt'),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: state.decrypt,
              icon: const Icon(Icons.arrow_upward_rounded),
              label: const Text('Decrypt'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        BinaryInputWidget(
          data: state.cipherTextInput,
          label: 'Cipher Text',
        ),
        // Column(
        //   children: [
        //     const Text('base64CipherTextOutput'),
        //     SelectableText(state.base64CipherOutput),
        //   ],
        // ),
      ],
    ).container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      constraints: const BoxConstraints(maxWidth: 400),
    );
  }
}

class Argon2PasswordView extends StatelessWidget {
  const Argon2PasswordView({
    super.key,
    required this.state,
  });

  final RustCryptoState state;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Column(
        children: [
          const Text('ARGON2').title(),
          const SizedBox(height: 8),
          TextField(
            controller: state.saltController,
            decoration: InputDecoration(
              labelText: 'Salt (base64)',
              suffixIcon: IconButton(
                onPressed: state.generateSalt,
                icon: const Icon(Icons.refresh),
              ),
            ),
          ),
          BinaryInputWidget(
            data: state.passwordInput,
            label: 'Password',
          ),
          const SizedBox(height: 5),
          SelectableText(
            'Is Password Verified: ${state.isPasswordVerified ?? '-'}',
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: state.hashPassword,
                icon: const Icon(Icons.arrow_downward_rounded),
                label: const Text('Hash Password'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: state.verifyPassword,
                icon: const Icon(Icons.arrow_upward_rounded),
                label: const Text('Verify Password'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: state.passwordHashController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Password Hash (PHC)',
              suffixIcon: AnimatedBuilder(
                animation: state.passwordHashController,
                builder: (context, _) =>
                    copyButton(state.passwordHashController.text),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Argon2ConfigWidget(
            config: state.argon2config,
            passwordSecret: state.passwordSecret,
            onChanged: state.setArgon2Config,
          ),
        ],
      ).container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        constraints: const BoxConstraints(maxWidth: 400),
      ),
    );
  }
}

class Argon2ConfigWidget extends StatelessWidget {
  const Argon2ConfigWidget({
    super.key,
    required this.config,
    required this.onChanged,
    required this.passwordSecret,
  });

  final Argon2Config config;
  final void Function(Argon2Config) onChanged;
  final BinaryInputData passwordSecret;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const Text('Argon2 Configuration').subtitle(),
          ToggleButtonsW(
            value: config.version,
            options: Argon2Version.values,
            setValue: (v) => onChanged(config.copyWith(version: v)),
          ),
          ToggleButtonsW(
            value: config.algorithm,
            options: Argon2Algorithm.values,
            setValue: (v) => onChanged(config.copyWith(algorithm: v)),
            width: 70,
          ),
          Row(
            children: [
              Expanded(
                child: IntInput(
                  initialValue: config.outputLength,
                  onChanged: (v) =>
                      onChanged(config.copyWith(outputLength: Some(v))),
                  label: 'Output Length',
                ),
              ),
              Expanded(
                child: IntInput(
                  initialValue: config.memoryCost,
                  onChanged: (v) => onChanged(config.copyWith(memoryCost: v)),
                  label: 'Memory Cost',
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Row(
            children: [
              Expanded(
                child: IntInput(
                  initialValue: config.timeCost,
                  onChanged: (v) => onChanged(config.copyWith(timeCost: v)),
                  label: 'Time Cost',
                ),
              ),
              Expanded(
                child: IntInput(
                  initialValue: config.parallelismCost,
                  onChanged: (v) =>
                      onChanged(config.copyWith(parallelismCost: v)),
                  label: 'Parallelism Cost',
                ),
              ),
            ],
          ),
          BinaryInputWidget(
            data: passwordSecret,
            label: 'Secret',
          ),
        ],
      ),
    );
  }
}

class BinaryInputWidget extends StatelessWidget {
  const BinaryInputWidget({
    super.key,
    required this.data,
    required this.label,
  });

  final BinaryInputData data;
  final String label;

  @override
  Widget build(BuildContext context) {
    final file = data.file;
    return Column(
      children: [
        BinaryDataEncodingButtons(data: data),
        if (data.encoding == InputEncoding.file)
          Card(
            child: Column(
              children: [
                SizedBox(height: 54, child: Text(file!.name).subtitle()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () => downloadFile(file.name, file.bytes),
                      icon: const Icon(Icons.download),
                      label: const Text('Download'),
                    ),
                    const SizedBox(width: 6),
                    Text(file.bytes.sizeHuman),
                    const SizedBox(width: 6),
                    TextButton(
                      onPressed: () => data.encodingSet(InputEncoding.file),
                      child: const Text('Pick File'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
            ),
          ).container(constraints: const BoxConstraints(maxWidth: 500))
        else
          TextField(
            controller: data.textController,
            maxLines: data.isKey ? 3 : 4,
            style: data.isKey
                ? const TextStyle(fontSize: 12)
                : const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: data.generate != null
                  ? Column(
                      children: [
                        IconButton(
                          onPressed: data.generate,
                          icon: const Icon(Icons.refresh),
                        ),
                        copyButton(data.textController.text),
                      ],
                    )
                  : copyButton(data.textController.text),
            ),
          ),
      ],
    );
  }
}

Widget copyButton(String text) {
  return IconButton(
    iconSize: 16,
    onPressed: () => Clipboard.setData(
      ClipboardData(text: text),
    ),
    icon: const Icon(Icons.copy),
  );
}

class BinaryDataEncodingButtons extends StatelessWidget {
  const BinaryDataEncodingButtons({super.key, required this.data});

  final BinaryInputData data;

  @override
  Widget build(BuildContext context) {
    return ToggleButtonsW(
      value: data.encoding,
      setValue: data.encodingSet,
      options: data.allowedEncodings,
    );
  }
}

class ToggleButtonsW<T extends Enum> extends StatelessWidget {
  const ToggleButtonsW({
    super.key,
    required this.options,
    required this.value,
    required this.setValue,
    this.width = 60,
  });

  final T value;
  final void Function(T) setValue;
  final List<T> options;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      constraints: const BoxConstraints(minHeight: 35),
      isSelected: options.map((e) => e == value).toList(),
      onPressed: (index) {
        setValue(options[index]);
      },
      children: [
        ...options.map(
          (e) => Text(e.name).container(
            alignment: Alignment.center,
            width: width,
          ),
        ),
      ],
    );
  }
}
