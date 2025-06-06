{ pkgs, pluginPkgs }:

let
  inherit (pkgs) lib;

  vimPlugins = pkgs.vimPlugins // pluginPkgs;

  callVimPlugin = lib.callPackageWith (vimPlugins // pkgs);

  normalizePlugin =
    {
      plugin,
      config ? null,
      optional ? false,
      ...
    }:
    if config ? lua then
      {
        plugin = plugin.overrideAttrs (prev: {
          passthru = prev.passthru // {
            initLua = if prev.passthru ? initLua then "${prev.passthru.initLua}\n${config.lua}" else config.lua;
          };
        });
        inherit optional;
      }
    else
      { inherit plugin config optional; };

  importVimPlugin = path: normalizePlugin (callVimPlugin path { });
in

lib.filesystem.listFilesRecursive ./.
|> builtins.filter (f: f != ./default.nix)
|> map importVimPlugin
