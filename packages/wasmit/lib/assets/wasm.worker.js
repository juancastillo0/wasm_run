// @ts-check
"use strict";

/** @type {WorkerData | undefined} */
let workerData;

/** @type {number | undefined} */
let workerId;

/**
 * @param {PostMessage} data
 */
function sendMessage(data) {
  self.postMessage(data);
}

/**
 * @typedef {Object} MapImportsArgs2
 * @property {WebAssembly.Imports} imports
 * @property {number} workerId
 * @property {WebAssembly.Module} module
 * @property {(message: any) => void} postMessage
 */

/**
 * @param {WasmImportsLoadParam} param
 * @returns {WebAssembly.Imports}
 */
function mapImports(param) {
  /** @type {WebAssembly.Imports} */
  const wasmImports = {};
  if (param) {
    for (const moduleName in param) {
      const map = wasmImports[moduleName] || {};
      wasmImports[moduleName] = map;

      const moduleImports = param[moduleName];
      for (const importName in moduleImports) {
        const value = moduleImports[importName];
        if (value === null || value === undefined) {
          continue;
        }
        if (
          typeof value === "number" ||
          typeof value === "function" ||
          value instanceof WebAssembly.Global ||
          value instanceof WebAssembly.Memory ||
          value instanceof WebAssembly.Table
        ) {
          map[importName] = value;
        } else if ("element" in value) {
          value.initial = value.initial || value["minimum"];
          delete value["minimum"];
          map[importName] = new WebAssembly.Table(value, value.initialValue);
        } else if ("value" in value) {
          map[importName] = new WebAssembly.Global(value, value.initialValue);
        } else if ("shared" in value) {
          value.initial = value.initial || value["minimum"];
          delete value["minimum"];
          map[importName] = new WebAssembly.Memory(value);
        }
      }
    }
  }
  return wasmImports;
}

onmessage = (e) => {
  /** @type {number | undefined} */
  let taskId;

  try {
    /** @type {MessageData} */
    const data = e.data;
    if (data.cmd === "load") {
      workerId = data.workerId;

      let wasmImports = mapImports(data.wasmImports);
      if (data.workerMapImportsScriptUrl) {
        importScripts(data.workerMapImportsScriptUrl);

        /** @type {MapImportsArgs2} */
        const args = {
          imports: wasmImports,
          module: data.wasmModule,
          postMessage: (arg) => {
            sendMessage({
              cmd: "event",
              data: arg,
            });
          },
          workerId: data.workerId,
        };
        if (typeof self["mapWorkerWasmImports"] == "function") {
          wasmImports = self.mapWorkerWasmImports(args);
        } else {
          throw new Error(
            "mapWorkerWasmImports is not defined in workerMapImportsScriptUrl"
          );
        }
      }
      const instance = new WebAssembly.Instance(data.wasmModule, wasmImports);
      workerData = {
        wasmInstance: instance,
        wasmModule: data.wasmModule,
        workerId: data.workerId,
      };
      sendMessage({
        cmd: "loaded",
        workerId: workerData.workerId,
      });
    } else if (data.cmd === "run") {
      taskId = data.taskId;
      if (!workerData) {
        throw new Error("Worker Instance not loaded");
      }
      try {
        const func = workerData.wasmInstance.exports[data.functionExport];
        if (!func) {
          throw new Error(
            "functionExport " + data.functionExport + " not found"
          );
        } else if (typeof func !== "function") {
          throw new Error(
            "functionExport " + data.functionExport + " is not a function"
          );
        } else if (func.length !== data.args.length) {
          throw new Error(
            "functionExport " +
              data.functionExport +
              " has different number of arguments"
          );
        }
        const result = func(...data.args);
        sendMessage({
          cmd: "result",
          taskId: data.taskId,
          result,
          isUndefined: result === undefined,
          workerId: workerData.workerId,
        });
      } catch (ex) {
        sendMessage({
          cmd: "alert",
          didThrow: true,
          taskId: data.taskId,
          text: ex.message,
          workerId: workerData.workerId,
        });
      }
      // } else if (data.cmd === "cancel") {
      //   if (Module["_pthread_self"]()) {
      //     Module["__emscripten_thread_exit"](-1);
      //   }
    } else {
      threadPrintErr("wasm.worker.js received unknown command" + data);
    }
  } catch (ex) {
    let text =
      "wasm.worker.js onmessage() captured an uncaught exception: " + ex;
    if (ex && ex.stack) text = text + ex.stack;

    sendMessage({
      cmd: "alert",
      didThrow: true,
      taskId,
      text,
      workerId,
    });
    throw ex;
  }
};

function threadPrintErr() {
  const text = Array.prototype.slice.call(arguments).join(" ");
  console.error(text);

  sendMessage({
    cmd: "alert",
    text: text,
    workerId,
    didThrow: false,
    taskId: undefined,
  });
}

/**
 * @typedef {Object} WorkerData
 * @property {number} workerId
 * @property {WebAssembly.Instance} wasmInstance
 * @property {WebAssembly.Module} wasmModule
 */

/**
 * @typedef {Record<string, Record<string, WebAssembly.ImportValue
 *  | (WebAssembly.TableDescriptor & {initialValue?: any})
 *  | (WebAssembly.GlobalDescriptor & {initialValue?: any})
 *  | WebAssembly.MemoryDescriptor>> | undefined} WasmImportsLoadParam
 */

/**
 * @typedef {Object} MessageDataLoad
 * @property {"load"} cmd
 * @property {number} workerId
 * @property {WebAssembly.Module} wasmModule
 * @property {WasmImportsLoadParam} wasmImports
 * @property {string | null} workerMapImportsScriptUrl
 */

/**
 * Message that stars the execution of a task
 * @typedef {Object} MessageDataRun
 * @property {"run"} cmd
 * @property {number} taskId
 * @property {string} functionExport
 * @property {Array<unknown>} args
 */

/**
 * Message received from the main process
 * @typedef {(MessageDataLoad | MessageDataRun)} MessageData
 */

/**
 * Message sent when the WasmInstance has been loaded
 * @typedef {Object} PostMessageLoaded
 * @property {"loaded"} cmd
 * @property {number} workerId
 */

/**
 * Message sent when a task execution has completed
 * @typedef {Object} PostMessageResult
 * @property {"result"} cmd
 * @property {number} workerId
 * @property {number} taskId
 * @property {Array<unknown> | unknown} result
 * @property {boolean} isUndefined
 */

/**
 * Message sent to alert the main process
 * @typedef {Object} PostMessageAlert
 * @property {"alert"} cmd
 * @property {number | undefined} workerId
 * @property {number | undefined} taskId
 * @property {string} text
 * @property {boolean} didThrow
 */

/**
 * Message sent to alert the main process
 * @typedef {Object} PostMessageEvent
 * @property {"event"} cmd
 * @property {any} data
 */

/**
 * Message sent to main process
 * @typedef {(PostMessageLoaded | PostMessageResult | PostMessageAlert | PostMessageEvent)} PostMessage
 */
