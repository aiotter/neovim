# https://nixos.wiki/wiki/Tree_sitters
{ nvim-treesitter }: {
  plugin = nvim-treesitter.withAllGrammars;
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
