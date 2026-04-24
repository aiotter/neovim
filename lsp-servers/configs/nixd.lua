return {
  settings = {
    nixd = {
      formatting = { command = { "sh", "-c", 'nix fmt -- "$@" || nixfmt "$@"' } },
    },
  },
}
