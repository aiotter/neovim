# Available servers:
# https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

# LS for Rust is configured at rust-tools-nvim plugin configuration

{ pkgs }:

let
  erlls = pkgs.callPackage ./erlls {};
  tailwindcss-lsp = (import ./tailwindcss { inherit pkgs; })."@tailwindcss/language-server";

  # sourcekitPath = if pkgs.stdenv.isDarwin then "sourcekit-lsp" else "${pkgs.swift}/bin/sourcekit-lsp";
  # add this below: lspconfig.sourcekit.setup { cmd = { "${sourcekitPath}" } }

  pylsp = pkgs.python3.withPackages (
    ps: with ps; [ python-lsp-server pyls-isort /** pylsp-mypy **/ ]
      ++ (with python-lsp-server.optional-dependencies; builtins.concatLists [ pycodestyle autopep8 ])
  );
in

''
  lua <<EOF
  ${pkgs.lib.fileContents ./server_configurations.lua}

  local lspconfig = require("lspconfig")
  local util = require("lspconfig.util")

  lspconfig.erlls.setup { cmd = { "${erlls}/bin/erlls" } }
  lspconfig.gopls.setup { cmd = { "${pkgs.gopls}/bin/gopls" } }
  lspconfig.pyright.setup { cmd = { "${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio" } }
  lspconfig.svelte.setup { cmd = { "${pkgs.nodePackages.svelte-language-server}/bin/svelteserver", "--stdio" } }
  lspconfig.terraformls.setup { cmd = { "${pkgs.terraform-ls}/bin/terraform-ls", "serve" } }
  -- lspconfig.zls.setup { cmd = { "$${pkgs.zls}/bin/zls" } } -- https://github.com/NixOS/nixpkgs/issues/290102


  lspconfig.nil_ls.setup {
    cmd = { "${pkgs.nil}/bin/nil" },
    settings = {
      ['nil'] = {
        formatting = { command = { "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" } },
      },
    },
  }

  local prettier = {
    formatCommand = "${pkgs.nodePackages.prettier}/bin/prettier --stdin-filepath ''${INPUT}",
    formatStdin = true,
  }

  lspconfig.efm.setup {
    settings = {
      rootMarkers = { ".prettierrc", ".git/" },
      languages = {
        javascript = { prettier },
        typescript = { prettier },
        html = { prettier },
      },
      -- logLevel = 4,
    },
    init_options = { documentFormatting = true },
    cmd = { "${pkgs.efm-langserver}/bin/efm-langserver" },
    filetypes = { "javascript", "typescript", "html" },
  }

  lspconfig.fortls.setup { cmd = { "${pkgs.fortls}/bin/fortls", "--config=${builtins.toFile ".fortls" (builtins.toJSON {
      notify_init = true;
      hover_signature = true;
      hover_language = "fortran";
      # use_signature_help = true;
      lowercase_intrinsics = true;
      disable_autoupdate = true;
    })}" } }

  lspconfig.tailwindcss.setup {
    cmd = { "${tailwindcss-lsp}/bin/tailwindcss-language-server", "--stdio" }
  }

  lspconfig.denols.setup {
    cmd = { "${pkgs.deno}/bin/deno", "lsp" },
    -- init_options = { importMap = vim.fn.findfile("import_map.json", vim.api.nvim_buf_get_name(0) .. ";") and vim.fn.fnamemodify(vim.fn.findfile("import_map.json", vim.api.nvim_buf_get_name(0) .. ";"), ":p") },
    root_dir = util.root_pattern("deno.json", "deno.jsonc"),
  }

  lspconfig.tsserver.setup {
    cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" },
    root_dir = util.root_pattern("tsconfig.json"),
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
  EOF
''
