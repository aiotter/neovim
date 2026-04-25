final: prev:

let
  inherit (final) lib;
in

{
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
