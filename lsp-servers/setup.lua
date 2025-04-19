local lspconfig = require("lspconfig")
local util = require("lspconfig.util")


lspconfig.erlls.setup {}
lspconfig.gopls.setup {}
lspconfig.pyright.setup {}
lspconfig.svelte.setup {}
lspconfig.terraformls.setup {}
-- lspconfig.zls.setup {} -- https://github.com/NixOS/nixpkgs/issues/290102

-- lspconfig.nextls.setup {
--   init_options = {
--     -- extensions = {
--     --   credo = { enable = true }
--     -- },
--     experimental = {
--       completions = { enable = true }
--     }
--   }
-- }

-- lspconfig.nil_ls.setup {
--   settings = {
--     ['nil'] = {
--       formatting = { command = { "$${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" } },
--     },
--   },
-- }

lspconfig.nixd.setup {
  settings = {
    nixd = {
      formatting = { command = { "nixfmt" } },
    },
  },
}

-- lspconfig.tailwindcss.setup {
--   cmd = { "$\{tailwindcss-lsp}/bin/tailwindcss-language-server", "--stdio" }
-- }

lspconfig.denols.setup {
  -- init_options = { importMap = vim.fn.findfile("import_map.json", vim.api.nvim_buf_get_name(0) .. ";") and vim.fn.fnamemodify(vim.fn.findfile("import_map.json", vim.api.nvim_buf_get_name(0) .. ";"), ":p") },
  root_dir = util.root_pattern("deno.json", "deno.jsonc"),
}

lspconfig.ts_ls.setup {
  root_dir = util.root_pattern("tsconfig.json"),
  single_file_support = false,
}

lspconfig.pylsp.setup {
  cmd = { "${pylsp}/bin/pylsp" },
  settings = {
    pylsp = {
      plugins = {
        autopep8 = { enabled = true },
        jedi_completion = { enabled = false },
        jedi_definition = { enabled = false },
        jedi_hover = { enabled = false },
        jedi_references = { enabled = false },
        jedi_signature_help = { enabled = false },
        jedi_symbols = { enabled = false },
        mccabe = { enabled = false },
        preload = { enabled = false },
        pycodestyle = { enabled = true },
        pyflakes = { enabled = false },
        yapf = { enabled = false },
        rope_autoimport = { enabled = true },
      },
    },
  },
}

lspconfig.tilt_ls.setup {}
vim.treesitter.language.register("starlark", "tiltfile")
