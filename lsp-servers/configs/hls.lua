return {
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
  settings = {
    haskell = {
      formattingProvider = "fourmolu",
      plugin = {
        -- https://github.com/haskell/haskell-language-server/issues/4674
        hlint = { globalOn = false, diagnosticsOn = false },
      },
    },
  },
}
