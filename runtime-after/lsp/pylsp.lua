return {
  settings = {
    pylsp = {
      plugins = {
        autopep8 = { enabled = true },
        jedi_completion = { enabled = false },
        jedi_definition = { enabled = false },
        jedi_hover = { enabled = false },
        jedi_references = { enabled = false },
        jedi_signature_help = { enabled = false },
        jedi_symbols = { enabled = false },
        mccabe = { enabled = false },
        preload = { enabled = false },
        pycodestyle = { enabled = true },
        pyflakes = { enabled = false },
        yapf = { enabled = false },
        rope_autoimport = { enabled = true },
      },
    },
  },
}
