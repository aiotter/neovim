{ rust-tools-nvim, rust-analyzer, rustfmt }:
let
  rust-analyzer-with-rustfmt = rust-analyzer.overrideAttrs (prev: {
    buildInputs = [ rustfmt ];
  });
in
{
  plugin = rust-tools-nvim;
  config.lua = ''
    require("rust-tools").setup {
      tools = {
        inlay_hints = {
          -- parameter_hints_prefix = " <- ",
          -- other_hints_prefix = " => ",
          max_len_align = true,
          highlight = "NonText",
        },
      },
      server = {
        cmd = { "${rust-analyzer-with-rustfmt}/bin/rust-analyzer" },
      },
    }
  '';
}
