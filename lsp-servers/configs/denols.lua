return {
  on_init = function(client)
    -- Stop deno LS when ts_ls is active
    local ts_ls_clients = vim.lsp.get_clients({ name = "ts_ls", bufnr = 0 })
    if #ts_ls_clients > 0 then
      client:stop()
    end
  end,
}
