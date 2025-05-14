{ pkgs, pluginPkgs }:

let
  inherit (pkgs) lib;

  vimPlugins = pkgs.vimPlugins // pluginPkgs;

  callVimPlugin = lib.callPackageWith (vimPlugins // pkgs);

  normalizePlugin =
    {
      plugin ? null,
      config ? null,
      optional ? false,
      ...
    }@input:
    if builtins.isNull plugin then
      { plugin = input; }
    else if config ? lua then
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

  importVimPlugins =
    path: callVimPlugin path { } |> pkgs.lib.toList |> map normalizePlugin;
in

lib.filesystem.listFilesRecursive ./.
|> builtins.filter (f: f != ./default.nix)
|> map importVimPlugins
|> pkgs.lib.flatten
