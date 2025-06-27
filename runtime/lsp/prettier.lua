local prettier = {
  formatCommand = "prettier --stdin-filepath ${INPUT}",
  formatStdin = true,
}

return {
  cmd = { "efm-langserver" },
  name = "prettier",
  settings = {
    -- rootMarkers = { ".prettierrc", ".git/" },
    languages = {
      javascript = { prettier },
      typescript = { prettier },
      html = { prettier },
    },
    -- logLevel = 4,
  },
  init_options = { documentFormatting = true },
  root_markers = { ".prettierrc", ".git/" },
  filetypes = { "javascript", "typescript", "html" },
}
