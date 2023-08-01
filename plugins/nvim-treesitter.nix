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

    -- Remove conceal in some languages
    -- query = require('vim.treesitter.query')
    -- for _, lang in ipairs({'json', 'markdown', 'markdown_inline'}) do
    --   local queries = {}
    --   for _, file in ipairs(query.get_files(lang, 'highlights')) do
    --     for _, line in ipairs(vim.fn.readfile(file)) do
    --       local line_sub = line:gsub([[%(#set! conceal ""%)]], ''')
    --       table.insert(queries, line_sub)
    --     end
    --   end
    --   query.set(lang, 'highlights', table.concat(queries, '\n'))
    -- end
    EOF
  '';
}
