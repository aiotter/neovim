{ rustaceanvim, rust-analyzer, rustfmt }:
let
  rust-analyzer-with-rustfmt = rust-analyzer.overrideAttrs (prev: {
    buildInputs = [ rustfmt ];
  });
in
{
  plugin = rustaceanvim;
  config.lua = ''
    vim.g.rustaceanvim = {
      server = {
        cmd = { "${rust-analyzer-with-rustfmt}/bin/rust-analyzer" },
      }
    }
  '';
}
