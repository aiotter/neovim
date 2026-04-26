final: prev:

let
  inherit (final) lib stdenv;
in

{
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        ln -s "$out/share/applications/org.neovim.nvim.desktop" "$out/share/applications/nvim.desktop"
      '';
  });

  nixfmt = prev.nixfmt.overrideAttrs (old: {
    patches = old.patches or [ ] ++ [
      (final.fetchpatch {
        name = "allow-single-line-list.patch";
        url = "https://github.com/NixOS/nixfmt/pull/353.patch";
        hash = "sha256-iE58XhEIKNVrFz8WHMsUYZ8NrGVBtmxAal4xLICu5kk=";
      })
    ];
  });

  vimPlugins = prev.vimPlugins // {
    hmts-nvim = prev.vimPlugins.hmts-nvim.overrideAttrs (old: {
      patches = old.patches or [ ] ++ [
        (final.fetchpatch {
          name = "handle-nil.patch";
          url = "https://github.com/calops/hmts.nvim/pull/38.patch";
          hash = "sha256-GXqUtqqhbkJCSkLJ3cz4AgiY3mKpAAg2F4aQhEjZVtM=";
        })
      ];
    });
  };
}
