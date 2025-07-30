return {
  root_markers = { "package.json" },
  workspace_required = true,
  on_init = function()
    -- Stop deno LS when ts_ls is active
    local denols_clients = vim.lsp.get_clients({ name = "denols", bufnr = 0 })
    for _, client in ipairs(denols_clients) do
      client:stop()
    end
  end,
}
