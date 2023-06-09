// @ts-check
"use strict";

/**
 * @param {MapImportsArgs} args
 * @returns {WebAssembly.Imports}
 */
function mapWorkerWasmImports(args) {
  args.imports["threaded_imports"] = {
    /** @type {(state: bigint) => bigint} imports */
    host_map_state: (state) => {
      args.postMessage({
        kind: "call",
        function: "host_map_state",
        arg: state,
        workerId: args.workerId,
      });
      return state + 1n;
    },
  };
  return args.imports;
}
