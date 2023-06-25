import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:flutter_example/rust_crypto_state.dart';
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
    final isSmall = MediaQuery.of(context).size.width < 850;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        if (isSmall) {
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: HashAndHmacView(state: state),
                      ),
                      SingleChildScrollView(child: Aes256GcmView(state: state)),
                    ],
                  ),
                ),
                const TabBar(
                  tabs: [
                    Tab(child: Text('HASH & MAC')),
                    Tab(child: Text('AES GCM SIV')),
                  ],
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
    final allowedEncodings = data.allowedEncodings;
    return ToggleButtons(
      constraints: const BoxConstraints(minHeight: 35),
      isSelected: allowedEncodings.map((e) => e == data.encoding).toList(),
      onPressed: (index) {
        data.encodingSet(allowedEncodings[index]);
      },
      children: [
        ...allowedEncodings.map(
          (e) => Text(e.name).container(alignment: Alignment.center, width: 60),
        ),
      ],
    );
  }
}
