return {
  before_init = function ()
    vim.treesitter.language.register("starlark", "tiltfile")
  end,
}
