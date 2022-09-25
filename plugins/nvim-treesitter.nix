# https://nixos.wiki/wiki/Tree_sitters
{ nvim-treesitter }: {
  plugin = nvim-treesitter.withPlugins (plugins: builtins.attrValues plugins);
  config = ''
    lua <<EOF
    require'nvim-treesitter.configs'.setup {
      highlight = {
        enable = true,
        disable = {},
      },
    }
    EOF
  '';
}
