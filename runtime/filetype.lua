vim.filetype.add({
  filename = {
    Tiltfile = "tiltfile",
  },
  pattern = {
    -- Infer the base filetype from the filename before the .eex suffix.
    [".+%.eex"] = function(path)
      local original_name = vim.fs.basename(path):gsub("%.eex$", "")
      return vim.filetype.match({ filename = original_name }) or "eelixir"
    end,
  },
})
