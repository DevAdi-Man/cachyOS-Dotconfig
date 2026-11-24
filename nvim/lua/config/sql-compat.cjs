const { registerHooks } = require("node:module");

// SQL Language Server 1.7 uses private paths removed by its current dependencies.
const publicImports = new Map([
  ["vscode-languageserver-protocol/lib/common/protocol", "vscode-languageserver-protocol"],
  ["vscode-jsonrpc/lib/node/main", "vscode-jsonrpc/node"],
]);

registerHooks({
  resolve(specifier, context, nextResolve) {
    return nextResolve(publicImports.get(specifier) ?? specifier, context);
  },
});
