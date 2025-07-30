return {
  cmd = { "erlls" },
  filetypes = { "erlang" },
  root_markers = { "rebar.config", "erlang.mk", ".git" },
  capabilities = {
    general = { positionEncodings = { "utf-16" } },
    workspace = { workspaceEdit = { documentChanges = true } },
  },
  -- settings = {
  --   erlls = { erlLibs = "/opt/homebrew/lib/erlang/lib:_checkouts:_build/default/lib" },
  -- },
}
