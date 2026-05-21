final: prev:

let
  inherit (final) lib;
in

{
  wrapNeovimUnstable = neovim-unwrapped: attrs:
    (prev.wrapNeovimUnstable neovim-unwrapped attrs).overrideAttrs (old: {
      postBuild = lib.replaceStrings
        [
          ''
            rm $out/share/applications/nvim.desktop
            substitute ${neovim-unwrapped}/share/applications/nvim.desktop $out/share/applications/nvim.desktop \
          ''
        ]
        [
          ''
            rm -f $out/share/applications/nvim.desktop
            desktopFile=${neovim-unwrapped}/share/applications/nvim.desktop
            if [ ! -e "$desktopFile" ]; then
              desktopFile=${neovim-unwrapped}/share/applications/org.neovim.nvim.desktop
            fi
            substitute "$desktopFile" $out/share/applications/nvim.desktop \
          ''
        ]
        old.postBuild;
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
