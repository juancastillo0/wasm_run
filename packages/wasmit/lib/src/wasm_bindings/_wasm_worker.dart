@JS()
library wasm_worker;

import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util' as js_util;
import 'dart:typed_data';

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart'
    show JS, anonymous;
import 'package:wasmit/src/wasm_bindings/_atomics_web.dart';
import 'package:wasmit/src/wasm_bindings/wasm_interface.dart';

/// A task that can be run in a [WasmWorker].
class WorkerTask {
  /// The name of the wasm function to call.
  final String functionName;

  /// The arguments to pass to the function.
  final List<Object?> args;

  /// The completer that will be completed when the task is done.
  final Completer<List<Object?>> completer = Completer();

  /// A task that can be run in a [WasmWorker].
  WorkerTask(this.functionName, this.args);

  @override
  String toString() {
    return 'WorkerTask(functionName: $functionName, args: $args,'
        ' completer: ${completer.isCompleted})';
  }
}

void postMessageToWorker(html.Worker worker, Object data) {
  js_util.callMethod<void>(worker, 'postMessage', [data]);
}

/// A wrapper around a [html.Worker] that can be used to run WASM code in a
/// separate Web Worker.
class WasmWorker {
  /// The id of the worker.
  final int workerId;

  /// The underlying [html.Worker].
  final html.Worker worker;

  final List<WasmFunction> _functions;
  final ByteData _byteData;

  late final StreamSubscription<dynamic> _subscription;
  final Completer<WasmWorker> _onLoaded = Completer();

  final WorkersConfig _workersConfig;

  /// The tasks that are currently running.
  final Map<int, WorkerTask> _tasks = {};
  int _lastTaskId = 0;

  WasmWorker._(
    this.workerId,
    this.worker,
    this._workersConfig,
    this._functions,
    this._byteData,
  ) {
    _subscription = worker.onMessage.listen(_handleMessage);
  }

  /// A wrapper around a [html.Worker] that can be used to run WASM code in a
  /// separate Web Worker.
  ///
  /// Creates and instantiates a new [WasmWorker] with the given [workerId]
  static Future<WasmWorker> create({
    required int workerId,
    required WorkersConfig workersConfig,
    required Map<String, Map<String, Object?>> wasmImports,
    required Object wasmModule,
    required List<WasmFunction> functions,
  }) {
    if (!html.Worker.supported) {
      throw UnsupportedError('Web Workers are not supported');
    }
    final sharedBuffer = html.SharedArrayBuffer(256);
    final byteData =
        js_util.callConstructor<ByteData>(_dataViewConstructor, [sharedBuffer]);
    final worker = html.Worker(workersConfig.workerScriptUrl);

    final wasmWorker =
        WasmWorker._(workerId, worker, workersConfig, functions, byteData);
    worker.onError.listen(wasmWorker._onLoaded.completeError);

    postMessageToWorker(
      worker,
      js_util.jsify({
        'cmd': 'load',
        'wasmImports': wasmImports,
        'wasmModule': wasmModule,
        'workerId': workerId,
        'sharedBuffer': sharedBuffer,
        'workerMapImportsScriptUrl': workersConfig.workerMapImportsScriptUrl
      }) as Object,
    );
    return wasmWorker._onLoaded.future;
  }

  /// Runs the given [task] in the worker.
  Future<List<Object?>> run(WorkerTask task) {
    _tasks[++_lastTaskId] = task;
    final data = js_util.jsify({
      'cmd': 'run',
      'args': <Object?>[],
      'functionExport': task.functionName,
      'taskId': _lastTaskId,
    }) as Object;

    // TODO: we do this to support JsBigInts
    final args = js_util.getProperty<Object>(data, 'args');
    for (final arg in task.args) {
      js_util.callMethod<void>(args, 'push', [arg]);
    }

    postMessageToWorker(worker, data);
    return task.completer.future;
  }

  /// Terminates the worker.
  void dispose() {
    _subscription.cancel();
    worker.terminate();
  }

  @override
  String toString() {
    return 'WasmWorker(workerId: $workerId, worker: $worker,'
        ' _onLoaded: ${_onLoaded.isCompleted}, _tasks: $_tasks,'
        ' _lastTaskId: $_lastTaskId)';
  }

  void _handleMessage(html.MessageEvent event) {
    if (event.data is String) {
      print(event.data);
      return;
    }
    final data_ = (event.data as Map).cast<String, Object?>();
    switch (data_['cmd']) {
      case 'loaded':
        _onLoaded.complete(this);
        break;
      case 'call':
        final functionId = data_['functionId']! as int;
        final function = _functions[functionId];
        final args = data_['args']! as List;
        final results = function(args);
        final bytes = _byteData;

        int offset = 4;
        int i = 0;
        for (final type in function.results!) {
          final value = results[i++]!;
          switch (type) {
            case ValueTy.i32:
              bytes.setInt32(offset += 4, value as int, Endian.little);
              break;
            case ValueTy.f32:
              bytes.setFloat32(offset += 4, value as double, Endian.little);
              break;
            case ValueTy.i64:
              i64.setInt64(bytes, offset += 8, value, Endian.little);
              break;
            case ValueTy.f64:
              bytes.setFloat64(offset += 8, value as double, Endian.little);
              break;
            case ValueTy.v128:
            case ValueTy.externRef:
            case ValueTy.funcRef:
              // TODO: implement refs
              throw UnimplementedError();
          }
        }
        atomics.notify(Int32List.sublistView(bytes), 0, 1);
        break;
      case 'event':
        _workersConfig.onWorkerMessage?.call(js_util.dartify(data_['data']));
        break;
      case 'result':
        final data = _PostMessageResult.fromJson(data_);
        final taskId = data.taskId;
        final List<Object?> result;
        if (data.isUndefined) {
          result = [];
        } else if (data.result is List) {
          result = (data.result! as List).cast();
        } else {
          result = [data.result];
        }
        _tasks.remove(taskId)!.completer.complete(result);
        break;
      case 'alert':
        final data = _PostMessageAlert.fromJson(data_);
        final taskId = data.taskId;
        if (taskId != null) {
          _tasks.remove(taskId)!.completer.completeError(data);
        } else if (!_onLoaded.isCompleted) {
          _onLoaded.completeError(data);
        } else {
          print(data);
        }
        break;
      default:
        print('Unknown worker message: $data_');
    }
  }
}

@JS('DataView')
external Object get _dataViewConstructor;

// @JS('sendSharedMemoryToWorker')
// external void sendSharedMemoryToWorker(
//   Object worker,
//   Object wasmModule,
//   Object sharedMemory,
// );

@JS()
@anonymous
class _MessageDataLoad {
  ///
  external factory _MessageDataLoad({
    required String cmd,
    required int workerId,
    required Object wasmModule,
    required Object wasmMemory,
    required Object wasmImports,
  });
}

@JS()
@anonymous
class _MessageDataRun {
  ///
  external factory _MessageDataRun({
    required String cmd,
    required int taskId,
    required String functionExport,
    required List<Object?> args,
  });
}

class _PostMessageLoaded {
  final String cmd;
  final int workerId;

  _PostMessageLoaded({
    required this.cmd,
    required this.workerId,
  });
}

class _PostMessageResult {
  final String cmd;
  final int workerId;
  final int taskId;
  final Object? result;
  final bool isUndefined;

  _PostMessageResult({
    required this.cmd,
    required this.workerId,
    required this.taskId,
    required this.result,
    required this.isUndefined,
  });

  factory _PostMessageResult.fromJson(Map<String, Object?> json) {
    return _PostMessageResult(
      cmd: json['cmd']! as String,
      workerId: json['workerId']! as int,
      taskId: json['taskId']! as int,
      result: json['result'],
      isUndefined: json['isUndefined'] as bool? ?? false,
    );
  }
}

class _PostMessageAlert {
  final String cmd;
  final int? workerId;
  final int? taskId;
  final String? text;
  final bool didThrow;

  _PostMessageAlert({
    required this.cmd,
    required this.workerId,
    required this.taskId,
    required this.text,
    required this.didThrow,
  });

  factory _PostMessageAlert.fromJson(Map<String, Object?> json) {
    return _PostMessageAlert(
      cmd: json['cmd']! as String,
      workerId: json['workerId'] as int?,
      taskId: json['taskId'] as int?,
      text: json['text'] as String?,
      didThrow: json['didThrow'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'PostMessageAlert(cmd: $cmd, workerId: $workerId, taskId: $taskId,'
        ' text: $text, didThrow: $didThrow)';
  }
}
