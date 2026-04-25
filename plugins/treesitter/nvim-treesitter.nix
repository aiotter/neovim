# https://nixos.wiki/wiki/Tree_sitters
{ nvim-treesitter }: {
  plugin = nvim-treesitter.withAllGrammars;
  config.lua = ''
    -- enable highlight
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_auto_start", { clear = true }),
      callback = function(args)
        -- ignore errors when no parser is found for the filetype
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    -- disable on shellscript (tab in here doc is not preserved)
    local indent_disabled = { "markdown", "nix", "sh" }

    -- enable indentation
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_indent", { clear = true }),
      callback = function(args)
        local bufnr = args.buf
        local ft = vim.bo[bufnr].filetype
        if not vim.tbl_contains(indent_disabled, ft) then
          vim.bo[bufnr].indentexpr = "v:lua.vim.treesitter.indentexpr()"
        end
      end,
    })

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
  '';
}
