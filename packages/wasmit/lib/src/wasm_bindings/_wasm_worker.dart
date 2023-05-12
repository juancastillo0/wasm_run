@JS()
library wasm_worker;

import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart'
    show JS, anonymous;

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

/// A wrapper around a [html.Worker] that can be used to run WASM code in a
/// separate Web Worker.
class WasmWorker {
  /// The id of the worker.
  final int workerId;

  /// The underlying [html.Worker].
  final html.Worker worker;

  late final StreamSubscription<dynamic> _subscription;
  final Completer<WasmWorker> _onLoaded = Completer();

  /// The tasks that are currently running.
  final Map<int, WorkerTask> _tasks = {};
  int _lastTaskId = 0;

  WasmWorker._(this.workerId, this.worker) {
    _subscription = worker.onMessage.listen(_handleMessage);
  }

  /// A wrapper around a [html.Worker] that can be used to run WASM code in a
  /// separate Web Worker.
  ///
  /// Creates and instantiates a new [WasmWorker] with the given [workerId]
  static Future<WasmWorker> create({
    required int workerId,
    required Map<String, Object?> wasmImports,
    required Object wasmModule,
  }) {
    if (!html.Worker.supported) {
      throw UnsupportedError('Web Workers are not supported');
    }
    final worker = html.Worker('./packages/wasmit/assets/wasm.worker.js');

    final postMessage = js_util.callMethod<void Function(Object, Object)>(
      js_util.globalThis,
      'eval',
      ['(worker, data) => worker.postMessage(data)'],
    );

    final wasmWorker = WasmWorker._(workerId, worker);
    worker.onError.listen(wasmWorker._onLoaded.completeError);

    postMessage(
      worker,
      js_util.jsify({
        'cmd': 'load',
        'wasmImports': wasmImports,
        'wasmModule': wasmModule,
        'workerId': workerId
      }) as Object,
    );
    return wasmWorker._onLoaded.future;
  }

  /// Runs the given [task] in the worker.
  Future<List<Object?>> run(WorkerTask task) {
    _tasks[++_lastTaskId] = task;
    worker.postMessage(
      _MessageDataRun(
        cmd: 'run',
        args: task.args,
        functionExport: task.functionName,
        taskId: _lastTaskId,
      ),
    );
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
    }
  }
}

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
}
