local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local configs = require("lspconfig.configs")

if not configs.erlls then
  configs.erlls = {
    default_config = {
      cmd = { "erlls" },
      filetypes = { "erlang" },
      root_dir = util.root_pattern("rebar.config", "erlang.mk", ".git"),
      single_file_support = true,
      -- settings = {
      --   erlls = { erlLibs = "/opt/homebrew/lib/erlang/lib:_checkouts:_build/default/lib" },
      -- },
      capabilities = vim.tbl_deep_extend(
        "force",
        lspconfig.util.default_config.capabilities,
        {
          general = { positionEncodings = { "utf-16" } },
          workspace = { workspaceEdit = { documentChanges = true } },
        }
      ),
    },
  }
end
