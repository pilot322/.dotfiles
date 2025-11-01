return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    local dap = require("dap")

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
        skipFiles = { "<node_internals>/**", "node_modules/**" },
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
      },
    }

    dap.configurations.javascript = dap.configurations.typescript
  end,
}
