local prettier_filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "svelte",
  "vue",
  "css",
  "scss",
  "less",
  "html",
  "json",
  "jsonc",
  "yaml",
  "markdown",
  "graphql",
}

local prettier_filetypes_set = {}
for _, filetype in ipairs(prettier_filetypes) do
  prettier_filetypes_set[filetype] = true
end

local function apply_indent_config(bufnr, config)
  local buf_opts = vim.bo[bufnr]

  if type(config.useTabs) == "boolean" then
    buf_opts.expandtab = not config.useTabs
    if config.useTabs and config.tabWidth == nil then
      buf_opts.shiftwidth = 0
      buf_opts.softtabstop = 0
    end
  end

  if type(config.tabWidth) == "number" then
    buf_opts.tabstop = config.tabWidth
    if config.useTabs then
      buf_opts.shiftwidth = 0
      buf_opts.softtabstop = 0
    else
      buf_opts.shiftwidth = config.tabWidth
      buf_opts.softtabstop = -1
    end
  end
end

local function apply_prettier_indent(event)
  local bufnr = event.buf

  -- By the time this autocmd runs, the target buffer may already be invalid.
  if not vim.api.nvim_buf_is_valid(bufnr) then return end

  -- Skip special buffers like help, quickfix, and terminals.
  if vim.bo[bufnr].buftype ~= "" then return end

  if not prettier_filetypes_set[vim.bo[bufnr].filetype] then return end

  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == "" then return end

  vim.system(
    { "read-prettier-config", file },
    { cwd = vim.fs.dirname(file), text = true },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then return end

      local ok, config = pcall(vim.json.decode, result.stdout)
      if not ok or type(config) ~= "table" or not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      apply_indent_config(bufnr, config)
    end)
  )
end

local prettier_indent_group = vim.api.nvim_create_augroup("prettier-indent", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufFilePost" }, {
  group = prettier_indent_group,
  callback = apply_prettier_indent,
})
