return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "mason-org/mason.nvim",
  },
  config = function()
    local dap = require("dap")

    -- Uncomment to enable verbose DAP logging
    -- dap.set_log_level("TRACE")

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    dap.configurations.typescript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Fastify Server (tsx)",
        runtimeExecutable = "npx",
        runtimeArgs = { "tsx", "${workspaceFolder}/index.ts" },
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        skipFiles = { "<node_internals>/**", "**/node_modules/**" },
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
        env = {
          TZ = "UTC",
        },
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch current file (tsx)",
        runtimeExecutable = "npx",
        runtimeArgs = { "tsx", "${file}" },
        cwd = "${workspaceFolder}",
        skipFiles = { "<node_internals>/**", "**/node_modules/**" },
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Current Test File",
        autoAttachChildProcesses = true,
        skipFiles = { "<node_internals>/**", "**/node_modules/**" },
        program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
        runtimeExecutable = "node",
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        args = { "run", "${relativeFile}" },
        smartStep = true,
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Vitest (watch mode)",
        program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
        args = { "${relativeFile}", "--no-coverage", "--poolOptions.threads.singleThread" },
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        skipFiles = { "<node_internals>/**", "node_modules/**" },
        sourceMaps = true,
        pauseForSourceMap = true,
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
      },
    }

    dap.configurations.javascript = dap.configurations.typescript
  end,
}
